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
             :genres

  has_one :manga_library

  def manga_library
    scope && Consuming.where(user_id: scope.id, item_id: object.id, item_type: "Manga").first
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
