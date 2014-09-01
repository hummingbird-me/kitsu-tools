class ListBackup
  def initialize(user)
    @anime_entries = LibraryEntry.where(user: user)
    @manga_entries = MangaLibraryEntry.where(user: user)
  end

  def to_h
    {
      anime: @anime_entries.map { |a| Entities::MiniLibraryEntry.new(a) },
      manga: @manga_entries.map { |m| Entities::MiniMangaLibraryEntry.new(m) }
    }
  end
  def to_json(*args)
    to_h.to_json(*args)
  end
end
