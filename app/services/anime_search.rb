class AnimeSearch
  include ActiveModel::Model

  SHOW_TYPES = %w(OVA ONA Movie TV Special Music)

  SEASONS = %w(summer fall winter spring)

  attr_accessor :name,
                :slug,
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

  def apply anime

    anime.full_search(name) unless name.nil?

  end

  private

  def genres
    genres.split(',').map(&:to_i) - [0]
  end

end
