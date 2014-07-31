class LibraryEntryQuery

  # Parameters:
  # - user_id (required)
  # - recent (optional)
  # - page (optional)
  # - status (optional)
  # - include_private (optional)
  # - include_adult (optional)
  def self.find(params)
    library_entries = LibraryEntry.where(user_id: params[:user_id]).includes(:anime, anime: :genres).references(:anime, anime: :genres)

    if params[:recent]
      library_entries = library_entries.where(status: ["Currently Watching", "Plan to Watch"]).order('status, last_watched DESC').page(params[:page] || 1).per(6)
    end

    if params[:status]
      library_entries = library_entries.where(status: params[:status])
    end

    unless params[:include_private]
      library_entries = library_entries.where(private: false)
    end

    unless params[:include_adult]
      library_entries = library_entries.where("anime.age_rating <> 'R18+' OR anime.age_rating IS NULL").references(:anime)
    end

    library_entries
  end

end
