class MangaSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id,
             :romaji_title,
             :english_title,
             :poster_image,
             :synopsis,
             :chapter_count,
             :volume_count,
             :genres,
             :manga_type,
             :updated_at

  def id
    object.slug
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
end
