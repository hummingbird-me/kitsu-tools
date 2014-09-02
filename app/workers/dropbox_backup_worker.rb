class DropboxBackupWorker
  include Sidekiq::Worker

  DEBOUNCE_TIME = 2.minutes
  def self.perform_debounced(user_id)
    jid = $redis.get("dropbox_backup_jid:#{user_id}")
    if jid.nil? # Create job
      jid = perform_in(DEBOUNCE_TIME, user_id)
    else # Reset timer
      job = Sidekiq::ScheduledSet.new.find_job(jid)
      job.reschedule(DEBOUNCE_TIME.from_now)
    end
    $redis.set("dropbox_backup_jid:#{user_id}", jid, {ex: DEBOUNCE_TIME})
  end
  def perform(user_id)
    # Generate the backup
    user = User.find(user_id)
    backup = ListBackup.new(user)

    # Upload the backup
    client = Dropbox::API::Client.new(token: user.dropbox_token, secret: user.dropbox_secret)
    client.upload('library-backup.json', backup.to_json)

    # Clear any other dropbox-backup jobs queued for this user
    # Oh yeah and if it errors out, who even cares?
    Sidekiq::Queue.new.each { |j| j.delete if j.args[0] == user_id }
    begin
    rescue
    end
  end
end
