class UserSyncWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    client = DiscourseApi::Client.new(ENV['DISCOURSE_API_URL'], ENV['DISCOURSE_API_KEY'], 'System')
    sso = user.to_discourse_sso
    sso.sso_secret = ENV['DISCOURSE_SSO_SECRET']

    client.post("/admin/users/sync_sso", sso.payload)
  end
end
