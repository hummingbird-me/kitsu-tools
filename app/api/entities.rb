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
    expose(:alternate_title) {|anime, options| (anime.alternate_title(options[:title_language_preference]) and anime.alternate_title(options[:title_language_preference]).length > 0) ? anime.alternate_title(options[:title_language_preference]) : nil }
    expose :episode_count
    expose(:cover_image) {|anime, options| anime.poster_image_thumb }
    expose(:synopsis) {|anime, options| anime.synopsis }
    expose :show_type
    expose :genres, using: Entities::Genre, if: lambda {|anime, options| options[:genres].nil? or options[:genres] }
    expose :mal_id, if: lambda {|anime, options| options[:include_mal_id] }
  end

  class User < Grape::Entity
    expose :name
    expose(:avatar) {|user, options| user.avatar.url(:thumb) }
    expose(:cover_image) {|user, options| user.cover_image.url(:thumb) }
    expose :about
    expose :bio
    expose(:karma) {|user, options| user.reputation_for(:karma) }
    expose :life_spent_on_anime
    expose(:show_adult_content) {|user, options| !user.sfw_filter }
    expose :title_language_preference
    expose :last_library_update
    expose(:online) {|user, options| user.online? }
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
    expose(:rewatched_times) {|watchlist, options| watchlist.rewatch_count }
    expose :notes
    expose(:notes_present) {|watchlist, options| watchlist.notes and watchlist.notes.strip.length > 0 }
    expose(:status) {|watchlist, options| watchlist.status.downcase.gsub(' ', '-') }
    expose(:id) {|watchlist, options| Digest::MD5.hexdigest("^_^" + watchlist.id.to_s) }
    expose :private
    expose :rewatching

    expose :anime, using: Entities::Anime

    expose :rating do |watchlist, options|
      {
        type: options[:rating_type] || (watchlist.user.star_rating ? "advanced" : "simple"),
        value: watchlist.rating
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

    expose(:new_status,
      if: lambda {|substory, options| substory.substory_type == "watchlist_status_update" }
    ) do |substory, options|
      (substory.data["new_status"] || "Currently Watching").parameterize.underscore
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
      if substory.data["formatted_comment"].nil?
        formatted_comment = MessageFormatter.format_message substory.data["comment"]
        substory.data["formatted_comment"] = formatted_comment
        substory.save
      end
      substory.data["formatted_comment"]
    end

    expose(:permissions) do |substory, options|
      current_user ||= options[:current_user]
      if current_user and ((substory.user_id == current_user.id) or (substory.story.user_id == current_user.id) or current_user.admin?)
        {destroy: true}
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
