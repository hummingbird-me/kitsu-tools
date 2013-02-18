class Anime < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_title, :against => [:title, :alt_title], :using => [:tsearch, :trigram]

  extend FriendlyId
  friendly_id :title, :use => [:slugged]

  attr_accessible :title, :age_rating, :episode_count, :episode_length, :mal_id, :status, :synopsis, :cover_image

  has_attached_file :cover_image, :styles => { :thumb => "450x670!" }

  has_many :quotes
  has_many :castings
  has_many :reviews
  has_many :episodes
  has_many :recommendations
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :producers

  validates :title, :slug, :presence => true, :uniqueness => true

  # Filter out hentai if `filterp` is true or nil.
  def self.sfw_filter(current_user)
    if current_user && !current_user.sfw_filter
      self
    else
      where("age_rating <> 'Rx'")
    end
  end

  # Check whether the current anime is SFW.
  def sfw?
    age_rating != "Rx"
  end

  # Filter out all anime belonging to the genres passed in.
  def self.exclude_genres(genres)
    where('NOT EXISTS (SELECT 1 FROM anime_genres WHERE anime_genres.anime_id = anime.id AND anime_genres.genre_id IN (?))', genres.map(&:id))
  end

  # Find anime containing the genres passed in.
  def self.include_genres(genres)
    where('EXISTS (SELECT 1 FROM anime_genres WHERE anime_genres.anime_id = anime.id AND anime_genres.genre_id IN (?))', genres.map(&:id))
  end
end
