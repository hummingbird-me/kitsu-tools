class UserSyncWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    client = DiscourseApi::Client.new(ENV['DISCOURSE_API_URL'])
    sso = user.to_discourse_sso

    client.post("/admin/users/sync_sso", sso.payload)
  end
end
