class DropboxBackupWorker
  include Sidekiq::Worker

  DEBOUNCE_TIME = 2.minutes

  def self.perform_debounced(user_id)
    $redis.with do |conn|
      jid = conn.get("dropbox_backup_jid:#{user_id}")
      if jid.nil? # Create job
        jid = perform_in(DEBOUNCE_TIME, user_id)
      else # Reset timer
        job = Sidekiq::ScheduledSet.new.find_job(jid)
        job.reschedule(DEBOUNCE_TIME.from_now)
      end
      conn.set("dropbox_backup_jid:#{user_id}", jid, {ex: DEBOUNCE_TIME})
    end
  end

  def perform(user_id)
    # Generate the backup
    user = User.find(user_id)
    backup = ListBackup.new(user)

    # Upload the backup
    client = Dropbox::API::Client.new(token: user.dropbox_token, secret: user.dropbox_secret)
    begin
      client.upload('library-backup.json', backup.to_json)
    rescue Dropbox::API::Error::Unauthorized
      user.update(dropbox_token: nil, dropbox_secret: nil)
      return
    rescue Dropbox::API::Error::StorageQuota
      # TODO: notify the user
      return
    end

    # Update the last_backup timestamp
    user.update(last_backup: DateTime.now)
  end
end
