class MangaLibrariesController < ApplicationController
  def index
    if params[:user_id]
      user = User.find params[:user_id]

      manga_libraries = Consuming.where(user_id: user.id).includes(:item)

      manga_libraries = manga_libraries.where(status: params[:status]) if params[:status]

      # Filter private entries.
      manga_libraries = manga_libraries.where(private: false) if current_user != user

      # TODO: Filter adult entries.
      # unless user_signed_in? and !current_user.sfw_filter?
      #   manga_libraries = manga_libraries.where("manga.age_rating <> 'R18+' OR manga.age_rating IS NULL")
      # end

      render json: manga_libraries, :root => "manga_libraries"
    end
  end

  def update_manga_library_using_params(manga_library, params)
    library_params = get_library_params(params)
    [:status, :rating, :private, :parts_consumed, :blocks_consumed, :reconsuming, :reconsume_count].each do |x|
      if library_params.has_key? x
        manga_library[x] = library_params[x]
      end
    end

    if library_params.has_key? :is_favorite
      favorite_status = library_params[:is_favorite]
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

    library_params = get_library_params(params)
    manga = Manga.find_by(slug: library_params[:item_id]) 
    return error!("unknown manga id", 404) if manga.nil?

    manga_library = Consuming.where( user_id: current_user.id,
                                     item_id: manga.id,
                                     item_type: "Manga").first
    return error!("manga library entry already exists", 406) unless manga_library.nil?

    manga_library = Consuming.new(
      user_id: current_user.id,
      item_id: manga.id,
      item_type: "Manga",
      status: library_params[:status]
    )
    update_manga_library_using_params(manga_library, params)

    if manga_library.save
      render json: manga_library, :root => "manga_library"
    else
      return error!(manga_library.errors.full_messages * ', ', 500)
    end
  end

  def find_manga_library_by_id(id)
    manga_library = Consuming.find params[:id]
    (manga_library.user == current_user) ? manga_library : nil
  end

  def update
    authenticate_user!

    manga_library = find_manga_library_by_id params[:id]
    return error!("unauthorized", 403) if manga_library.nil?

    update_manga_library_using_params(manga_library, params)
    if manga_library.save
      render json: manga_library, :root => "manga_library"
    else
      return error!(manga_library.errors.full_messages * ', ', 500)
    end
  end

  def destroy
    authenticate_user!

    manga_library = find_manga_library_by_id params[:id]
    return error!("unauthorized", 403) if manga_library.nil?

    if manga_library.destroy
      render json: nil
    else
      return error!(manga_library.errors.full_messages * ', ', 500)
    end
  end

  private

  # THIS IS A SILLY HACK!
  # There is some issues with params names that come from ember
  # and i don't have time now to fix it properly
  # TODO: DO IT RIGHT!
  def get_library_params(params)
    return params[:manga_libraries] if not params[:manga_libraries].nil?
    return params[:manga_library] if not params[:manga_library].nil?
    return []
  end
end