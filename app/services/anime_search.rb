class AnimeSearch
  include ActiveModel::Model

  SHOW_TYPES = %w(OVA ONA Movie TV Special Music)

  SEASONS = %w(summer fall winter spring)

  SEASONS_MONTHS = {
    winter: %w(12 1 2),
    spring: %w(3 4 5),
    summer: %w(6 7 8),
    fall:   %w(9 10 11)
  }

  AGE_RATINGS = %w{G PG13 PG R17+}

  attr_accessor :name,
                :id,
                :show_type,
                :age_rating,
                :episode_count,
                :started_airing,
                :finished_airing,
                :genres,
                :season,
                :year

  with_options(allow_blank: true) do |item|
    item.validates :show_type, inclusion: SHOW_TYPES
    item.validates :season, inclusion: SEASONS
    item.validates :age_rating, inclusion: AGE_RATINGS
    item.validates :started_airing ,
                   :finished_airing,
                   format: {
                     with: /\d{4}-\d{2}-\d{2}/,
                     message: 'date must be formatted as YYYY-MM-DD'
                   }
    item.validates :year,
                   format: {
                     with: /\d{4}/,
                     message: 'year must be formatted as YYYY'
                   }
  end

  def apply_filters anime
    anime = anime.full_search(name) unless name.nil?
    anime = anime.where(slug: id) unless id.nil?
    anime = anime.where(show_type: show_type) unless show_type.nil?
    anime = anime.where(genres: { name: genres.split(',') }).joins(:genres) unless genres.nil?
    anime = anime.where(age_rating: age_rating) unless age_rating.nil?
    anime = anime.where(episode_count: episode_count) unless episode_count.nil?
    anime = anime.where('started_airing_date > ?', started_airing) unless started_airing.nil?
    anime = anime.where('finished_airing_date < ?', finished_airing) unless finished_airing.nil?
    anime = anime.where('EXTRACT(MONTH FROM started_airing_date) in (?)', SEASONS_MONTHS[season.to_sym]) unless season.nil?
    anime = anime.where('EXTRACT(YEAR FROM started_airing_date) = ?', year) unless year.nil?
    anime
  end

end
