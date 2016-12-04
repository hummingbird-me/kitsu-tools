class MangaLibraryEntriesController < ApplicationController
  ALLOWED_ONEBOXERS = %w[
    https://hibiki.plejeck.com
    https://forums.hummingbird.me
    https://forumstaging.hummingbird.me
    http://localhost:3000
  ]
  skip_before_action :verify_authenticity_token,
    if: -> { ALLOWED_ONEBOXERS.include?(request.headers['Origin']) && request.xhr? }

  def index
    if params[:user_id]
      user = User.find params[:user_id]

      manga_library_entries = MangaLibraryEntry.where(user_id: user.id).includes(:manga, manga: :genres).references(:manga, manga: :genres)

      manga_library_entries = manga_library_entries.where(status: params[:status]) if params[:status]

      # Filter private entries.
      manga_library_entries = manga_library_entries.where(private: false) if current_user != user

      render json: manga_library_entries
    end
  end

  def update_manga_library_entry_using_params(manga_library_entry, params)
    [:status, :rating, :private, :notes, :chapters_read, :volumes_read, :rereading, :reread_count].each do |x|
      if params[:manga_library_entry].has_key? x
        manga_library_entry[x] = params[:manga_library_entry][x]
      end
    end

    if params[:manga_library_entry].has_key? :is_favorite
      favorite_status = params[:manga_library_entry][:is_favorite]
      if favorite_status and !current_user.has_favorite?(manga_library_entry.manga)
        # Add favorite.
        Favorite.create(user: current_user, item: manga_library_entry.manga)
      elsif current_user.has_favorite?(manga_library_entry.manga) and !favorite_status
        # Remove favorite.
        current_user.favorites.where(item: manga_library_entry.manga).first.destroy
      end
    end
  end

  def create
    authenticate_user!
    manga = Manga.find_by(slug: params[:manga_library_entry][:manga_id]) 
    return error!("unknown manga id", 404) if manga.nil?

    manga_library_entry = MangaLibraryEntry.where( user_id: current_user.id,
                                     manga_id: manga.id).first
    return error!("manga library entry already exists", 406) unless manga_library_entry.nil?

    manga_library_entry = MangaLibraryEntry.new(
      user_id: current_user.id,
      manga_id: manga.id,
      status: params[:manga_library_entry][:status]
    )
    update_manga_library_entry_using_params(manga_library_entry, params)
    Action.manga_status(manga_library_entry)

    if manga_library_entry.save
      render json: manga_library_entry
    else
      return error!(manga_library_entry.errors.full_messages * ', ', 500)
    end
  end

  def find_manga_library_entry_by_id(id)
    manga_library_entry = MangaLibraryEntry.find params[:id]
    (manga_library_entry.user == current_user) ? manga_library_entry : nil
  end

  def update
    authenticate_user!

    manga_library_entry = find_manga_library_entry_by_id params[:id]
    return error!("Unauthorized", 403) if manga_library_entry.nil?

    update_manga_library_entry_using_params(manga_library_entry, params)
    Action.manga_status(manga_library_entry)

    if manga_library_entry.save
      render json: manga_library_entry, :root => "manga_library_entry"
    else
      return error!(manga_library_entry.errors.full_messages * ', ', 500)
    end
  end

  def destroy
    authenticate_user!

    manga_library_entry = find_manga_library_entry_by_id params[:id]
    return error!("Unauthorized", 403) if manga_library_entry.nil?

    if manga_library_entry.destroy
      render json: nil
    else
      return error!(manga_library_entry.errors.full_messages * ', ', 500)
    end
  end

  private

end
