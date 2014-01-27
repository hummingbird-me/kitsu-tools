# == Schema Information
#
# Table name: anime
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  alt_title                 :string(255)
#  slug                      :string(255)
#  age_rating                :string(255)
#  episode_count             :integer
#  episode_length            :integer
#  synopsis                  :text
#  youtube_video_id          :string(255)
#  mal_id                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  bayesian_average          :float            default(0.0)
#  user_count                :integer
#  thetvdb_series_id         :string(255)
#  thetvdb_season_id         :string(255)
#  english_canonical         :boolean          default(FALSE)
#  age_rating_guide          :string(255)
#  mal_age_rating            :string(255)
#  show_type                 :string(255)
#  started_airing_date       :date
#  finished_airing_date      :date
#  rating_frequencies        :hstore
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  cover_image_top_offset    :integer
#  ann_id                    :integer
#  started_airing_date_known :boolean          default(TRUE)
#

class Anime < ActiveRecord::Base
  include PgSearch
  pg_search_scope :fuzzy_search_by_title, against: [:title, :alt_title],
    using: [:trigram], ranked_by: ":trigram"
  pg_search_scope :simple_search_by_title, against: [:title, :alt_title],
    using: {:tsearch => {:normalization => 10}}, ranked_by: ":tsearch"

  extend FriendlyId
  friendly_id :canonical_title, :use => [:slugged, :history]

  attr_accessible :title, :age_rating, :episode_count, :episode_length, :mal_id, :ann_id, :synopsis, :cover_image, :cover_image_top_offset, :poster_image, :youtube_video_id, :alt_title, :franchises, :show_type, :thetvdb_series_id, :thetvdb_season_id, :english_canonical, :age_rating_guide, :started_airing_date, :started_airing_date_known, :finished_airing_date, :franchise_ids, :genre_ids, :producer_ids, :casting_ids

  has_attached_file :cover_image,
    styles: {thumb: ["1400x900>", :jpg]},
    convert_options: {thumb: "-quality 70 -colorspace Gray"}

  has_attached_file :poster_image, default_url: "/assets/missing-anime-cover.jpg",
    styles: {large: "200x290!", medium: "100x150!"}

  def poster_image_thumb
    if self.poster_image_file_name.nil?
      "http://hummingbird.me/assets/missing-anime-cover.jpg"
    else
      "http://static.hummingbird.me/anime/poster_images/#{"%03d" % (self.id/1000000 % 1000)}/#{"%03d" % (self.id/1000 % 1000)}/#{"%03d" % (self.id % 1000)}/large/#{self.poster_image_file_name}?#{self.poster_image_updated_at.to_i}"
    end
  end

  has_many :quotes, dependent: :destroy
  has_many :castings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :episodes, dependent: :destroy
  has_many :gallery_images, dependent: :destroy
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :producers
  has_and_belongs_to_many :franchises

  has_many :watchlists, dependent: :destroy

  validates :title, :presence => true, :uniqueness => true

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

  def self.order_by_popularity
    order('bayesian_average DESC NULLS LAST, user_count DESC NULLS LAST')
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
    self.poster_image = URI(meta[:poster_image_url]) if self.poster_image_file_name.nil?
    self.genres = (self.genres + meta[:genres]).uniq
    self.producers = (self.producers + meta[:producers]).uniq
    self.mal_age_rating = meta[:age_rating]
    self.age_rating, self.age_rating_guide = Anime.convert_age_rating(self.mal_age_rating)
    self.episode_count ||= meta[:episode_count]
    self.episode_length ||= meta[:episode_length]

    self.castings.select {|x| x.character and meta[:featured_character_mal_ids].include? x.character.mal_id }.each do |c|
      c.featured = true; c.save
    end

    self.started_airing_date = meta[:dates][:from]
    self.finished_airing_date = meta[:dates][:to]

    self.show_type = meta[:show_type] if meta[:show_type]

    self.save

    begin
      MalImport.create_series_castings(id)
    rescue
    end

  end

  def show_type_enum
    ["OVA", "ONA", "Movie", "TV", "Special", "Music"]
  end

  def status
    # If the started_airing_date is in the future or not specified, the show hasn't
    # aired yet.
    if started_airing_date.nil? or started_airing_date > Time.now.to_date
      return "Not Yet Aired"
    end

    # Since the show's airing date is in the past, it has either "Finished Airing" or
    # is "Currently Airing".

    # If the show has only one episode, then it has "Finished Airing".
    if episode_count == 1
      return "Finished Airing"
    end

    # If the finished_airing_date is specified and in the future, the the show is
    # "Currently Airing". If it is specified and in the past, then the show has
    # "Finished Airing". If it is not specified, the show is "Currently Airing".
    if finished_airing_date.nil?
      return "Currently Airing"
    else
      if finished_airing_date > Time.now.to_date
        return "Currently Airing"
      else
        return "Finished Airing"
      end
    end
  end

  before_save do
    # If episode_count has increased, create new episodes.
    if self.episode_count and self.episodes.length < self.episode_count and (self.episodes.length == 0 or self.thetvdb_series_id.nil? or self.thetvdb_series_id.length == 0) 
      (self.episodes.length+1).upto(self.episode_count) do |n|
        Episode.create(anime_id: self.id, number: n)
      end
    end
  end

  after_save do
    Rails.cache.write("anime_poster_image_thumb:#{self.id}", self.poster_image.url(:large))
  end

  def self.neon_alley_ids
    [11, 12, 244, 412, 777, 1376, 1377, 1445, 1555, 2245, 3817, 4989, 5044, 5187, 5940, 5953, 6028, 6084, 6477, 6590, 6614, 7753]
  end

  def similar(limit=20, options={})
    # FIXME
    return [] if Rails.env.development?

    exclude = options[:exclude] ? options[:exclude] : []
    similar_anime = []
    
    begin
      similar_json = JSON.load(open("http://app.vikhyat.net/anime_safari/related/#{self.id}")).select {|x| x["sim"] > 0.5 }.sort_by {|x| -x["sim"] }
      
      similar_json.each do |similar|
        sim = Anime.find_by_id(similar["id"])
        if sim and similar_anime.length < limit and (not self.sfw? or (self.sfw? and sim.sfw?))
          similar_anime.push(sim) unless exclude.include? sim
        end
      end
    rescue
    end
    
    similar_anime
  end
end
