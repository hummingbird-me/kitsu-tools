module Episodic
  extend ActiveSupport::Concern

  def recalculate_episode_length!
    # Try for the statistical mode (most common value) of episode lengths
    length, num = episodes.length_mode.values_at(:mode, :count)
    # If it's less than half of episodes, use average instead
    length = episodes.length_average if episode_count && num < (episode_count / 2)

    update(episode_length: length)
  end

  included do
    has_many :episodes, as: 'media', dependent: :destroy
    has_many :streaming_links, as: 'media', dependent: :destroy
  end
end
