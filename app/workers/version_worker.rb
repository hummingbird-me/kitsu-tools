class VersionWorker
  include Sidekiq::Worker

  def perform(version_id)
    version = Version.find(version_id)
    version.item.update_from_pending(version)
  end
end
