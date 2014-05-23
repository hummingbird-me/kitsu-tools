class UserSyncWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    open("http://forums.hummingbird.me/sync?secret=#{ENV['FORUM_SYNC_SECRET']}&auth_token=#{user.authentication_token}").read
  end
end
