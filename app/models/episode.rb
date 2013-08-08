class Episode < ActiveRecord::Base
  belongs_to :anime
  attr_accessible :anime_id, :number, :title, :anime, :season_number

  def episode_number
    number
  end

  validates :anime, :number, presence: true
  validates_uniqueness_of :number, scope: [:anime_id, :season_number]
  
  def title
    t = read_attribute(:title)
    if t.nil?
      return "Episode #{number}"
    else
      return t
    end
  end

  # How long the episode is, in minutes.
  def length
    anime.episode_length
  end
  
  # S01E01
  def format_season_episode
    s = season_number ? "s#{"%02d" % season_number}" : ""
    "#{s}e#{"%02d" % episode_number}"
  end
end
