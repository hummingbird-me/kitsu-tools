require 'net/http'

class StagingSyncWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    payload = {
      password_digest: user.encrypted_password,
      name: user.name,
      id: user.id,
      email: user.email,
      pro_expires_at: user.pro_expires_at
    }
    conn = Faraday::Connection.new('https://staging.kitsu.io/api/user/_prodsync')
    conn.basic_auth('Production', ENV['DISCOURSE_SSO_SECRET'])
    conn.post(nil, payload)
    raise "Bad response: #{conn.body}" if conn.status != 200
  end
end
