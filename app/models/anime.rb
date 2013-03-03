class Anime < ActiveRecord::Base
  include PgSearch
  pg_search_scope :fuzzy_search_by_title, against: [:title, :alt_title], 
    using: [:trigram], ranked_by: ":trigram"
  pg_search_scope :simple_search_by_title, against: [:title, :alt_title], 
    using: {:tsearch => {:normalization => 10}}, ranked_by: ":tsearch"

  extend FriendlyId
  friendly_id :title, :use => [:slugged]

  attr_accessible :title, :age_rating, :episode_count, :episode_length, :mal_id, :status, :synopsis, :cover_image, :youtube_video_id

  has_attached_file :cover_image, 
    :styles => { :thumb => "225x335!", :"thumb@2x" => "450x670!" },
    :url => "/system/:hash_:style.:extension",
    :hash_secret => "Tsukiakari no Michishirube"

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
