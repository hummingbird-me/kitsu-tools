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
#  synopsis                  :text             default(""), not null
#  youtube_video_id          :string(255)
#  mal_id                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  bayesian_rating           :float            default(0.0), not null
#  user_count                :integer          default(0), not null
#  thetvdb_series_id         :integer
#  thetvdb_season_id         :integer
#  english_canonical         :boolean          default(FALSE)
#  age_rating_guide          :string(255)
#  show_type                 :string(255)
#  started_airing_date       :date
#  finished_airing_date      :date
#  rating_frequencies        :hstore           default({}), not null
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  cover_image_top_offset    :integer          default(0), not null
#  ann_id                    :integer
#  started_airing_date_known :boolean          default(TRUE), not null
#  jp_title                  :text
#

class Anime < ActiveRecord::Base
  PG_TITLE_SCOPE = %i(title alt_title)

  AGE_RATINGS = %w(G PG13 PG R18+)

  SHOW_TYPES = %w(OVA ONA Movie TV Special Music)

  SEASONS = %w(summer fall winter spring)

  SEASONS_MONTHS = {
    winter: %w(12 1 2),
    spring: %w(3 4 5),
    summer: %w(6 7 8),
    fall:   %w(9 10 11)
  }

  include Media

  friendly_id :canonical_title, use: %i(slugged history)

  with_options(dependent: :destroy) do |a|
    a.has_many :reviews
    a.has_many :episodes
    a.has_many :gallery_images
    a.has_many :stories, as: :target
    a.has_many :library_entries
    a.has_many :quotes
  end

  # TODO: this will be used once we decide to unify library stuff
  # has_many :consumings, as: :item
  has_and_belongs_to_many :producers
  has_and_belongs_to_many :franchises

  validates :title, presence: true, uniqueness: true

  friendly_id :canonical_title, use: %i(slugged history)

  default_scope { preload(:genres) }

  scope :exclude_genres, ->(genres) {
    where('NOT EXISTS (
            SELECT 1
            FROM anime_genres
            WHERE anime_genres.anime_id = anime.id
            AND anime_genres.genre_id IN (?)
          )', genres.map(&:id))
  }

  # Find anime containing the genres passed in.
  # This complicated bit of SQL basically does relational division.
  scope :include_genres, ->(genres) {
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
  }

  scope :by_season, ->(season) {
    where('EXTRACT(MONTH FROM started_airing_date) in (?)',
          self::SEASONS_MONTHS[season.to_sym])
  }

  scope :by_year, ->(year) {
    where('EXTRACT(YEAR FROM started_airing_date) = ?', year)
  }

  scope :by_started_date, ->(date, direction = :after) {
    return where('started_airing_date > ?', date) if direction == :after
    return where('started_airing_date < ?', date) if direction == :before
  }

  scope :by_finished_date, ->(date, direction = :before) {
    return where('finished_airing_date > ?', date) if direction == :after
    return where('finished_airing_date < ?', date) if direction == :before
  }

  scope :order_by_rating, lambda {
    order('bayesian_rating DESC NULLS LAST, user_count DESC NULLS LAST')
  }

  scope :by_genres, ->(genres) {
    genres = genres.split(',') if genres.is_a?(String)
    where(genres: { name: genres }).joins(:genres)
  }

  # Filter out hentai if `filterp` is true or nil.
  def self.sfw_filter(current_user)
    if current_user && !current_user.sfw_filter
      self
    else
      where("age_rating <> 'R18+'")
    end
  end

  before_validation do
    self.cover_image_top_offset = 0 if cover_image_top_offset.nil?
  end

  # Check whether the current anime is SFW.
  def sfw?
    age_rating != 'R18+'
  end

  # Use this function to get the title instead of directly accessing the title.
  # preference = canonical | english | romanized
  def canonical_title(preference = '')
    if preference.class == User
      preference = preference.title_language_preference
    end

    case preference
    when 'canonical'
      english_canonical && alt_title.present? ? alt_title : title
    when 'english'
      alt_title.present? ? alt_title : title
    else
      title
    end
  end

  # Use this function to get the alt title instead of directly accessing the
  # alt_title.
  def alternate_title(preference = '')
    if preference.class == User
      preference = preference.title_language_preference
    end

    case preference
    when 'canonical'
      english_canonical && alt_title.present? ? title : alt_title
    when 'english'
      alt_title.present? ? title : alt_title
    else
      alt_title
    end
  end

  def title_distance(title)
    titles = [self.title, alt_title].compact
    # Damerau-Levenshtein Distance
    levenshtein = titles.map do |t|
      RubyFish::DamerauLevenshtein.distance(t, title)
    end

    # Longest Common Subsequence (Normalized
    subsequence = titles.map do |t|
      [t, RubyFish::LongestSubsequence.distance(t, title)]
    end
    subsequence = subsequence.map do |t|
      [t[0].length, title.length].max - t[1]
    end

    # Average and square to determine cost
    [levenshtein.min, subsequence.min]
      .flatten
      .map { |x| x**2 }
      .instance_eval { sum.to_f / size }
  end

  def self.fuzzy_find(title)
    # Exact
    anime = Anime.find_by('lower(title) = :title OR lower(alt_title) = :title',
                          title: title.downcase)
    return anime unless anime.nil?

    # Trigram
    options = Anime.full_search(title).first(10)
    anime = options.first
    return anime if !anime.nil? && anime.pg_search_rank > 0.7

    # Sort by distance, ascending
    anime = options.map do |a|
      {
        anime: a,
        distance: a.title_distance(title)
      }
    end
    anime = anime.sort { |a, b| a[:distance] <=> b[:distance] }

    anime.first[:anime] if anime.first[:distance] < 80
  end

  def self.create_or_update_from_hash(hash)
    # First the creation logic
    # TODO: stop hard-coding the ID column
    anime = Anime.find_by(mal_id: hash[:external_id])
    if anime.nil? && Anime.where(title: hash[:title][:canonical]).count > 1
      log "Could not find unique Anime by
           title=#{hash[:title][:canonical]}. Ignoring."
      return
    end
    anime ||= Anime.find_by(title: hash[:title][:canonical])
    anime ||= Anime.new

    # Metadata
    anime.assign_attributes({
      mal_id: (hash[:external_id] if anime.mal_id.blank?),
      title: (hash[:title][:canonical] if anime.title.blank?),
      alt_title: (hash[:title][:ja_en] if anime.alt_title.blank?),
      synopsis: (hash[:synopsis] if anime.synopsis.blank?),
      poster_image: (hash[:poster_image] if anime.poster_image.blank?),
      show_type: (hash[:type] if anime.show_type.blank?),
      genres: (begin
                 hash[:genres].map { |g| Genre.find_by name: g }.compact
               rescue
                 return []
               end if anime.genres.blank?),
      producers: (begin
                    hash[:producers]
                    .map { |p| Producer.find_by name: p }
                    .compact
                  rescue
                    return []
                  end if anime.producers.blank?),
      # These fields are always more accurate elsewhere
      age_rating: hash[:age_rating],
      age_rating_guide: hash[:age_rating_guide],
      episode_count: hash[:episode_count],
      episode_length: hash[:episode_length],
      started_airing_date: begin hash[:dates][0] rescue nil end,
      finished_airing_date: begin hash[:dates][1] rescue nil end
    }.compact)
    anime.save!
    # Staff castings
    hash[:staff] ||= []
    hash[:staff].each do |staff|
      Casting.create_or_update_from_hash staff.merge(castable: anime)
    end
    # VA castings
    hash[:characters] ||= []
    hash[:characters].each do |ch|
      character = Character.create_or_update_from_hash ch
      if ch[:voice_actors].length > 0
        ch[:voice_actors].each do |actor|
          Casting.create_or_update_from_hash actor.merge(
            featured: ch[:featured],
            character: character,
            castable: anime
          )
        end
      else
        Casting.create_or_update_from_hash(
          featured: ch[:featured],
          character: character,
          castable: anime
        )
      end
    end
    anime
  end

  def show_type_enum
    SHOW_TYPES
  end

  def status
    # If the started_airing_date is in the future or not specified,
    # the show hasn't aired yet.
    if started_airing_date.nil? || started_airing_date > Time.zone.now.to_date
      return 'Not Yet Aired'
    end

    # If the show has only one episode, then it has "Finished Airing".
    return 'Finished Airing' if episode_count == 1

    # If the finished_airing_date is specified and in the future,
    # the the show is "Currently Airing".
    # If it is specified and in the past, then the show has "Finished Airing".
    # If it is not specified, the show is "Currently Airing".
    if finished_airing_date.nil?
      return 'Currently Airing'
    else
      if finished_airing_date > Time.zone.now.to_date
        return 'Currently Airing'
      else
        return 'Finished Airing'
      end
    end
  end

  before_save do
    # If episode_count has increased, create new episodes.
    if episode_count &&
       episodes.length < episode_count &&
       (episodes.length == 0 || thetvdb_series_id.nil?)

      (episodes.length + 1).upto(episode_count) do |n|
        Episode.create(anime_id: id, number: n)
      end
    end
  end

  after_save do
    hash_name = "anime_poster_image_thumb:#{id}"
    Rails.cache.write(hash_name, poster_image.url(:large))
  end

  def similar(limit = 20, options = {})
    # FIXME
    return [] if Rails.env.development?

    exclude = options[:exclude] ? options[:exclude] : []
    similar_anime = []

    json = JSON.load(open("http://app.vikhyat.net/anime_graph/related/#{id}"))
    similar_json = json.select { |x| x['sim'] > 0.5 }
                   .sort_by { |x| -x['sim'] }

    similar_json.each do |similar|
      sim = Anime.find_by_id(similar['id'])
      similar_anime.push(sim) if sim &&
                                 similar_anime.length < limit &&
                                 (!self.sfw? || (self.sfw? && sim.sfw?)) &&
                                 !exclude.include?(sim)
    end

    similar_anime
  rescue
    return []
  end

  # Versionable overrides
  def create_pending(author, obj = {})
    # check if URL is the same, otherwise paperclip will determine
    # that it is a new image based on `original` filesize compared to
    # the linked thumbnail filesize.
    obj.delete(:poster_image) if obj[:poster_image] == poster_image.url(:large)
    obj.delete(:cover_image) if obj[:cover_image] == cover_image.url(:thumb)

    obj[:started_airing_date] = obj.delete(:started_airing)
    obj[:finished_airing_date] = obj.delete(:finished_airing)
    super
  end
end
