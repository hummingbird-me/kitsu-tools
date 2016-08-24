module Episodic
  extend ActiveSupport::Concern

  def recalculate_episode_length!
    # Try for the statistical mode (most common value) of episode lengths
    length, num = episodes.length_mode.values_at(:mode, :count)
    # If it's less than half of episodes, use average instead
    if episode_count && num < (episode_count / 2)
      length = episodes.length_average
    end

    update(episode_length: length)
  end

  def default_progress_limit
    # Weekly with a margin
    if run_length
      (run_length.to_i / 7) + 5
    else
      100
    end
  end

  included do
    has_many :episodes, as: 'media', dependent: :destroy
    has_many :streaming_links, as: 'media', dependent: :destroy
    alias_attribute :progress_limit, :episode_count
  end
end
