class LibraryEntriesController < ApplicationController
  def index
    if params[:user_id]
      user = User.find params[:user_id]
      library_entries = LibraryEntry.where(user_id: user.id)

      # Filter private entries.
      if current_user != user
        library_entries = library_entries.where(private: false)
      end

      # Filter adult entries.
      if user_signed_in? and !current_user.sfw_filter?
        library_entries = library_entries.includes(:anime)
      else
        library_entries = library_entries.includes(:anime).where("anime.age_rating <> 'R18+' OR anime.age_rating IS NULL").references(:anime)
      end

      render json: library_entries
    end
  end

  def update_library_entry_using_params(library_entry, params)
    [:status, :rating, :private, :episodes_watched, :rewatching, :rewatch_count, :notes].each do |x|
      if params[:library_entry].has_key? x
        library_entry[x] = params[:library_entry][x]
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
      render json: library_entry
    else
      return error!(library_entry.errors.full_messages * ', ', 500)
    end
  end
end
