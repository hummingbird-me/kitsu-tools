class SubstoryReaperWorker
  include Sidekiq::Worker

  def perform(story_id)
    Substory.where(story_id: story_id).find_each do |substory|
      substory.destroy!
    end
  end
end
