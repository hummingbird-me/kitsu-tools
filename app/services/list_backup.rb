class ListBackup
  def initialize(user)
    @anime_entries = LibraryEntry.where(user: user)
    @manga_entries = MangaLibraryEntry.where(user: user)
  end

  def to_h
    {
      anime: @anime_entries.map { |a| present_anime_library_entry(a) },
      manga: @manga_entries.map { |m| present_manga_library_entry(m) }
    }
  end

  def to_json(*args)
    to_h.to_json(*args)
  end

  private

  def present_anime_library_entry(library_entry)
    {
      episodes_watched: library_entry.episodes_watched,
      last_watched: (library_entry.last_watched || library_entry.updated_at),
      rewatch_count: library_entry.rewatch_count,
      rewatching: library_entry.rewatching,
      notes: library_entry.notes,
      status: library_entry.status.downcase.gsub(' ', '_'),
      private: library_entry.private,
      rating: library_entry.rating,
      anime: present_anime(library_entry.anime)
    }
  end

  def present_anime(anime)
    {
      id: anime.id,
      slug: anime.slug,
      status: anime.status,
      english_title: anime.alt_title,
      romaji_title: anime.title,
      episode_count: anime.episode_count,
      show_type: anime.show_type
    }
  end

  def present_manga_library_entry(library_entry)
    {
      chapters_read: library_entry.chapters_read,
      volumes_read: library_entry.volumes_read,
      last_read: (library_entry.last_read || library_entry.updated_at),
      reread_count: library_entry.reread_count,
      rereading: library_entry.rereading,
      notes: library_entry.notes,
      status: library_entry.status.downcase.gsub(' ', '_'),
      private: library_entry.private,
      rating: library_entry.rating,
      manga: present_manga(library_entry.manga)
    }
  end

  def present_manga(manga)
    h = {}
    [:id, :slug, :status, :english_title, :romaji_title, :volume_count,
     :chapter_count, :manga_type].each do |key|
      h[key] = manga.send(key)
    end
    h
  end
end
