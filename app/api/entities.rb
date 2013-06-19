module Entities
  class Genre < Grape::Entity
    expose :name
  end

  class Anime < Grape::Entity
    expose :slug
    expose(:url) {|anime, options| anime_path(anime) }
    expose(:title) {|anime, options| anime.canonical_title(options[:title_language_preference]) }
    expose :episode_count
    expose(:cover_image) {|anime, options| anime.cover_image.url(:thumb) }
    expose(:short_synopsis) {|anime, options| anime.synopsis.truncate(380, separator: ' ') }
    expose :show_type
    expose :genres, using: Entities::Genre
  end
  
  class MiniUser < Grape::Entity
    expose :name
    expose(:url) {|user, options| user_path(user) }
    expose(:avatar) {|user, options| user.avatar.url(:thumb) }
    expose(:avatar_small) {|user, options| user.avatar.url(:thumb_small) }
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
  
  class Substory < Grape::Entity
    expose :substory_type
    expose :created_at
    
    expose(
      :followed_user,
      if: lambda {|substory, options| substory.substory_type == "followed" }
    ) do |substory, options|
      Entities::MiniUser.represent substory.target
    end
  end
  
  class Story < Grape::Entity
    expose :story_type
    expose :user, using: Entities::MiniUser
    expose :substories, using: Entities::Substory

    expose :target, 
      as: :media, 
      if: lambda {|story, options| story.story_type == "media_story" }, 
      using: Entities::Anime

    expose(:substories_count) {|story, options| story.substories.count }
  end
end
