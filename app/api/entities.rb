require 'message_formatter'

module Entities
  class Genre < Grape::Entity
    expose :name
  end

  class Anime < Grape::Entity
    expose :slug
    expose :status
    expose(:url) {|anime, options| anime_path(anime) }
    expose(:title) {|anime, options| anime.canonical_title(options[:title_language_preference]) }
    expose :episode_count
    expose(:cover_image) {|anime, options| anime.cover_image.url(:thumb) }
    expose(:synopsis) {|anime, options| anime.synopsis }
    expose :show_type
    expose :genres, using: Entities::Genre, if: lambda {|anime, options| options[:genres].nil? or options[:genres] }
  end
  
  class MiniUser < Grape::Entity
    expose :name
    expose(:url) {|user, options| user_path(user) }
    expose(:avatar) {|user, options| user.avatar.url(:thumb) }
    expose(:avatar_small) {|user, options| user.avatar.url(:thumb_small) }
    expose(:nb) {|user, options| user.ninja_banned? }
  end
  
  class Quote < Grape::Entity
    expose :content
    expose :character_name
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
        value: watchlist.rating ? watchlist.rating : "-",
        positive: watchlist.positive?,
        negative: watchlist.negative?,
        neutral: watchlist.meh?,
        unknown: watchlist.rating.nil?
      }
    end
  end
  
  class Substory < Grape::Entity
    expose :id
    expose :substory_type
    expose :created_at
    
    expose(
      :followed_user,
      if: lambda {|substory, options| substory.substory_type == "followed" }
    ) do |substory, options|
      Entities::MiniUser.represent substory.target
    end
    
    expose(:quote,
      if: lambda {|substory, options| %w[liked_quote submitted_quote].include? substory.substory_type }
    ) do |substory, options|
      Entities::Quote.represent substory.target
    end
    
    expose(:new_status,
      if: lambda {|substory, options| substory.substory_type == "watchlist_status_update" }
    ) do |substory, options|
      substory.data["new_status"].parameterize.underscore
    end
    
    expose(:episode_number,
      if: lambda {|substory, options| substory.substory_type == "watched_episode" }
    ) do |substory, options|
      substory.data["episode_number"]
    end

    expose(:service,
      if: lambda {|substory, options| substory.substory_type == "watched_episode" }
    ) do |substory, options|
      substory.data["service"]
    end

    expose(:comment,
      if: lambda {|substory, options| substory.substory_type == "comment" }
    ) do |substory, options|
      MessageFormatter.format_message substory.data["comment"]
    end
    
    expose(:permissions) do |substory, options|
      current_ability ||= options[:current_ability]
      if current_ability
        {
          destroy: current_ability.can?(:destroy, substory)
        }
      else
        {}
      end
    end
  end
  
  class Story < Grape::Entity
    expose :id

    expose :story_type
    expose :user, using: Entities::MiniUser
    expose :substories, using: Entities::Substory
    expose :updated_at

    expose(:media, if: lambda {|story, options| story.story_type == "media_story" }) {|story, options| Entities::Anime.represent(story.target, options) }
    expose(:poster, if: lambda {|story, options| story.story_type == "comment" }) {|story, options| Entities::MiniUser.represent(story.target, options) }

    expose(:self_post, if: lambda {|story, options| story.story_type == "comment" }) {|story, options| story.target == story.user }

    expose(:substories_count) {|story, options| story.substories.length }
  end
end
