module Entities
  class Anime < Grape::Entity
    expose :slug
    expose(:url) {|anime, options| anime_path(anime) }
    expose(:title) {|anime, options| anime.canonical_title(nil) }
    expose :episode_count
    expose(:cover_image) {|anime, options| anime.cover_image.url(:thumb) }
    expose(:short_synopsis) {|anime, options| anime.synopsis.truncate(380, separator: ' ') }
    expose :show_type
  end
  
  class Watchlist < Grape::Entity
    expose :episodes_watched
    expose(:last_watched) {|watchlist, options| watchlist.last_watched || watchlist.updated_at }
    expose :rewatched_times
    expose :notes
    expose(:notes_present) {|watchlist, options| watchlist.notes and watchlist.notes.strip.length > 0 }
    expose :status
    expose(:status_parameterized) {|watchlist, options| watchlist.status.parameterize }
    expose(:id) {|watchlist, options| Digest::MD5.hexdigest("^_^" + watchlist.id.to_s) }
    expose :private

    expose :anime, using: Entities::Anime
    
    expose :rating do |watchlist, options|
      {
        type: {
          star_rating: watchlist.user.star_rating,
          simple: !watchlist.user.star_rating
        },
        value: watchlist.rating ? watchlist.rating + 3 : "-",
        positive: watchlist.positive?,
        negative: watchlist.negative?,
        neutral: watchlist.meh?,
        unknown: watchlist.rating.nil?
      }
    end
  end
end
