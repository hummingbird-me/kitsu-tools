class AnimeSearch
  include ActiveModel::Model

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
    item.validates :show_type, inclusion: Anime::SHOW_TYPES
    item.validates :season, inclusion: Anime::SEASONS
    item.validates :age_rating, inclusion: Anime::AGE_RATINGS
    item.validates :started_airing,
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

  def apply_filters(anime)
    anime = anime.full_search(name) unless name.nil?
    anime = anime.where(slug: id) unless id.nil?
    anime = anime.where(show_type: show_type) unless show_type.nil?
    anime = anime.by_genres(genres) unless genres.nil?
    anime = anime.where(age_rating: age_rating) unless age_rating.nil?
    anime = anime.where(episode_count: episode_count) unless episode_count.nil?
    anime = anime.by_started_date(started_airing) unless started_airing.nil?
    anime = anime.by_finished_date(finished_airing) unless finished_airing.nil?
    anime = anime.by_season(season) unless season.nil?
    anime = anime.by_year(year) unless year.nil?
    anime
  end

end
