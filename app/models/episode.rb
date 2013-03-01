class Episode < ActiveRecord::Base
  belongs_to :anime
  attr_accessible :anime_id, :number, :title

  validates :anime, :number, presence: true
  validates_uniqueness_of :number, scope: [:anime_id]

  has_and_belongs_to_many :watchlists, :uniq => true
  
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
end
