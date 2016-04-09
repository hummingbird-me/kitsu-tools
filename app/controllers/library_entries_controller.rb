require_dependency 'library_entry_query'

class LibraryEntriesController < ApplicationController
  ALLOWED_ONEBOXERS = %w[
    https://hibiki.plejeck.com
    https://forums.hummingbird.me
    https://forumstaging.hummingbird.me
    http://localhost:3000
  ]
  skip_before_action :verify_authenticity_token,
    if: -> { ALLOWED_ONEBOXERS.include?(request.headers['Origin']) && request.xhr? }
  def index
    unless params[:user_id]
      authenticate_user!
      params[:user_id] = current_user.id
    end

    user = User.find(params[:user_id])

    library_entries = LibraryEntryQuery.find(
      user_id: user.id,
      recent: params.has_key?(:recent),
      page: params[:page],
      status: params[:status],
      include_private: (current_user == user),
      include_adult: (user_signed_in? && !current_user.sfw_filter?)
    )

    render json: library_entries
  end

  def update_library_entry_using_params(library_entry, params)
    [:status, :rating, :private, :episodes_watched, :rewatching, :rewatch_count, :notes].each do |x|
      if params[:library_entry].has_key? x
        library_entry[x] = params[:library_entry][x]
      end
    end

    ## TEMPORARY -- Change when favorite status is moved into the library
    #               entry model.
    if params[:library_entry].has_key? :is_favorite
      favorite_status = params[:library_entry][:is_favorite]
      anime = library_entry.anime
      if favorite_status and !current_user.has_favorite?(anime)
        # Add favorite.
        Favorite.create(user: current_user, item: anime)
      elsif current_user.has_favorite?(anime) and !favorite_status
        # Remove favorite.
        current_user.favorites.where(item_id: anime, item_type: "Anime").first.destroy
      end
    end
  end

  def create
    authenticate_user!

    anime = Anime.find params[:library_entry][:anime_id]
    return error!("unknown anime id", 404) if anime.nil?

    library_entry = LibraryEntry.where(user_id: current_user.id,
                                       anime_id: anime.id).first
    return error!("library entry already exists", 406) unless library_entry.nil?

    library_entry = LibraryEntry.new({
      user_id: current_user.id,
      anime_id: anime.id,
      status: params[:library_entry][:status]
    })

    update_library_entry_using_params(library_entry, params)
    Action.from_library_entry(library_entry)

    if library_entry.save
      render json: library_entry
    else
      return error!(library_entry.errors.full_messages * ', ', 500)
    end
  end

  def find_library_entry_by_id(id)
    library_entry = LibraryEntry.find params[:id]
    (library_entry.user == current_user) ? library_entry : nil
  end

  def update
    authenticate_user!

    library_entry = find_library_entry_by_id params[:id]
    return error!("Unauthorized", 403) if library_entry.nil?

    update_library_entry_using_params(library_entry, params)
    Action.from_library_entry(library_entry)

    if library_entry.save
      render json: library_entry
    else
      return error!(library_entry.errors.full_messages * ', ', 500)
    end
  end

  def destroy
    authenticate_user!

    library_entry = find_library_entry_by_id params[:id]
    return error!("Unauthorized", 403) if library_entry.nil?

    if library_entry.destroy
      render json: nil
    else
      return error!(library_entry.errors.full_messages * ', ', 500)
    end
  end
end
