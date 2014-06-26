class MangaSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, 
             :romaji_title, 
             :english_title, 
             :cover_image, 
             :cover_image_top_offset, 
             :poster_image, 
             :synopsis, 
             :chapter_count, 
             :volume_count, 
             :genres,
             :type

  has_one :manga_library_entry

  def manga_library_entry
    scope && MangaLibraryEntry.where(user_id: scope.id, manga_id: object.id).first
  end
  def id
    object.slug
  end

  def cover_image
    object.cover_image.url(:thumb)
  end

  def genres
    object.genres.map {|x| x.name.parameterize }.sort
  end

  def poster_image
    object.poster_image.url(:large)
  end

  def include_english_title?
    object.english_title && object.english_title.strip.length > 0
  end

  def include_romaji_title?
    object.romaji_title && object.romaji_title.strip.length > 0
  end

  def include_cover_image?
    not object.cover_image_file_name.nil?
  end
end
