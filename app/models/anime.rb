class Anime < ActiveRecord::Base
  include PgSearch
  pg_search_scope :fuzzy_search_by_title, against: [:title, :alt_title], 
    using: [:trigram], ranked_by: ":trigram"
  pg_search_scope :simple_search_by_title, against: [:title, :alt_title], 
    using: {:tsearch => {:normalization => 10}}, ranked_by: ":tsearch"

  extend FriendlyId
  friendly_id :canonical_title, :use => [:slugged, :history]

  attr_accessible :title, :age_rating, :episode_count, :episode_length, :mal_id, 
    :status, :synopsis, :cover_image, :youtube_video_id, :alt_title, :franchises,
    :thetvdb_series_id, :thetvdb_season_id, :show_type, :english_canonical, 
    :age_rating_guide, :started_airing_date, :finished_airing_date

  has_attached_file :cover_image, 
    :styles => { :thumb => "225x335!", :"thumb@2x" => "450x670!" },
    :url => "/system/:hash_:style.:extension",
    :hash_secret => "Tsukiakari no Michishirube"

  has_many :quotes
  has_many :castings
  has_many :reviews
  has_many :episodes
  has_many :gallery_images
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :producers
  has_and_belongs_to_many :franchises

  has_many :watchlists

  validates :title, :slug, :presence => true, :uniqueness => true

  # Filter out hentai if `filterp` is true or nil.
  def self.sfw_filter(current_user)
    if current_user && !current_user.sfw_filter
      self
    else
      where("age_rating <> 'R18+'")
    end
  end

  # Check whether the current anime is SFW.
  def sfw?
    age_rating != "R18+"
  end

  # Use this function to get the title instead of directly accessing the title.
  def canonical_title(title_language_preference=nil)
    if title_language_preference and title_language_preference.class == User
      title_language_preference = title_language_preference.title_language_preference
    end
    
    if title_language_preference and title_language_preference == "romanized"
      return title
    elsif title_language_preference and title_language_preference == "english"
      return (alt_title and alt_title.length > 0) ? alt_title : title
    else
      return (alt_title and alt_title.length > 0 and english_canonical) ? alt_title : title
    end
  end

  # Use this function to get the alt title instead of directly accessing the 
  # alt_title.
  def alternate_title(title_language_preference=nil)
    if title_language_preference and title_language_preference.class == User
      title_language_preference = title_language_preference.title_language_preference
    end
    
    if title_language_preference and title_language_preference == "romanized"
      return alt_title
    elsif title_language_preference and title_language_preference == "english"
      return (alt_title and alt_title.length > 0) ? title : nil
    else
      return english_canonical ? title : alt_title
    end
  end

  # Filter out all anime belonging to the genres passed in.
  def self.exclude_genres(genres)
    where('NOT EXISTS (SELECT 1 FROM anime_genres WHERE anime_genres.anime_id = anime.id AND anime_genres.genre_id IN (?))', genres.map(&:id))
  end

  # Find anime containing the genres passed in.
  # This complicated bit of SQL basically does relational division.
  def self.include_genres(genres)
    where('NOT EXISTS (
            SELECT * FROM genres AS g
            WHERE g.id IN (?)
            AND NOT EXISTS (
              SELECT *
              FROM anime_genres AS ag
              WHERE ag.anime_id = anime.id
              AND   ag.genre_id = g.id
            )
          )', genres.map(&:id))
  end

  # Return [age rating, guide]
  def self.convert_age_rating(rating)
    {
      nil                               => [nil,    nil],
      ""                                => [nil,    nil],
      "None"                            => [nil,    nil],
      "PG-13 - Teens 13 or older"       => ["PG13", "Teens 13 or older"],
      "R - 17+ (violence & profanity)"  => ["R17+", "Violence, Profanity"],
      "R+ - Mild Nudity"                => ["R17+", "Mild Nudity"],
      "PG - Children"                   => ["PG",   "Children"],
      "Rx - Hentai"                     => ["R18+", "Hentai"],
      "G - All Ages"                    => ["G",    "All Ages"],
      "PG-13"                           => ["PG13", "Teens 13 or older"],
      "R+"                              => ["R17+", "Mild Nudity"],
      "PG13"                            => ["PG13", "Teens 13 or older"],
      "G"                               => ["G",    "All Ages"],
      "PG"                              => ["PG",   "Children"]
    }[rating] || [rating, nil]
  end
  
  def get_metadata_from_mal
    meta = MalImport.series_metadata(self.mal_id)
    self.title = meta[:title]
    self.alt_title = meta[:english_title]
    self.synopsis = meta[:synopsis]
    self.cover_image = URI(meta[:cover_image_url]) if self.cover_image_file_name.nil?
    self.genres = (self.genres + meta[:genres]).uniq
    self.producers = (self.producers + meta[:producers]).uniq
    self.mal_age_rating = meta[:age_rating]
    self.age_rating, self.age_rating_guide = Anime.convert_age_rating(self.mal_age_rating)
    self.episode_count ||= meta[:episode_count]
    self.episode_length ||= meta[:episode_length]
    self.status = meta[:status]

    self.castings.select {|x| x.character and meta[:featured_character_mal_ids].include? x.character.mal_id }.each do |c|
      c.featured = true; c.save
    end
    
    self.started_airing_date = meta[:dates][:from]
    self.finished_airing_date = meta[:dates][:to]

    self.save
  end

  def show_type_enum
    ["OVA", "ONA", "Movie", "TV"]
  end

  before_save do
    # If episode_count has increased, create new episodes.
    if self.episode_count and self.episodes.length < self.episode_count and (self.episodes.length == 0 or self.thetvdb_series_id.nil? or self.thetvdb_series_id.length == 0) 
      (self.episodes.length+1).upto(self.episode_count) do |n|
        Episode.create(anime_id: self.id, number: n)
      end
    end
  end

  def self.neon_alley_ids
    [11, 12, 244, 412, 777, 1376, 1377, 1445, 1555, 2245, 3817, 4989, 5044, 5187, 5940, 5953, 6028, 6084, 6477, 6590, 6614, 7753]
  end

  def similar(limit=20, options={})
    return [] unless mal_id
    
    exclude = options[:exclude] ? options[:exclude] : []
    similar_anime = []
    
    begin
      similar_json = JSON.load(open("http://app.vikhyat.net/anime_safari/related/#{mal_id}")).sort_by {|x| -x["sim"] }
      
      similar_json.each do |similar|
        sim = Anime.find_by_mal_id(similar["id"])
        if sim and similar_anime.length < limit
          similar_anime.push(sim) unless exclude.include? sim
        end
      end
    rescue
    end
    
    similar_anime
  end
end
