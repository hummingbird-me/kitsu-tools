class UserSyncWorker
  include Sidekiq::Worker

  def perform(user_id)
    open("http://forums.hummingbird.me/sync?secret=#{ENV['FORUM_SYNC_SECRET']}&user_id=#{user_id}").read
  end
end
