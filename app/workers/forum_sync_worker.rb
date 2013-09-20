class ForumSyncWorker
  include Sidekiq::Worker

  sidekiq_options throttle: {threshold: 2, period: 1.second}

  def perform(name)
    code = Digest::MD5.hexdigest("00577b4206ac32c260897b800e0df7b44dc7bfa78dafc8d028c067e35a17d" + name)
    open("http://forumsync.hummingbird.me:3000/sync?username=#{name}&code=#{code}").read
  end
end
