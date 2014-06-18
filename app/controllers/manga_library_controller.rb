class MangaLibrariesController < ApplicationController
  def index
    if params[:user_id]
      user = User.find params[:user_id]

      #if recent get the first 12 entries and then populate the nested models
      if params[:recent]
        manga_entries = Consuming.where(user_id: user.id, status: "Currently Watching").includes(:manga, manga: :genres).references(:manga, manga: :genres).order("consumings.updated_at DESC").limit(12)
      else
        manga_entries = Consuming.where(user_id: user.id).includes(:manga, manga: :genres).references(:manga, manga: :genres)
      end

      manga_entries = manga_entries.where(status: params[:status]) if params[:status]

      # Filter private entries.
      manga_entries = manga_entries.where(private: false) if current_user != user

      # TODO: Filter adult entries.
      # unless user_signed_in? and !current_user.sfw_filter?
      #   manga_entries = manga_entries.where("manga.age_rating <> 'R18+' OR manga.age_rating IS NULL").references(:manga)
      # end

      render json: manga_entries
    end
  end

  def update_library_entry_using_params(manga_library, params)
    [:status, :rating, :private, :parts_watched, :reconsuming, :reconsume_count].each do |x|
      if params[:manga_library].has_key? x
        manga_library[x] = params[:manga_library][x]
      end
    end

    if params[:manga_library].has_key? :is_favorite
      favorite_status = params[:manga_library][:is_favorite]
      if favorite_status and !current_user.has_favorite?(manga_library.item)
        # Add favorite.
        Favorite.create(user: current_user, item: manga_library.item)
      elsif current_user.has_favorite?(manga_library.item) and !favorite_status
        # Remove favorite.
        current_user.favorites.where(item_id: manga_library.item, item_type: "Manga").first.destroy
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
    return error!("unauthorized", 403) if library_entry.nil?

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
    return error!("unauthorized", 403) if library_entry.nil?

    if library_entry.destroy
      render json: nil
    else
      return error!(library_entry.errors.full_messages * ', ', 500)
    end
  end
end