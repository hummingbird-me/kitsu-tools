class MangaSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :romaji_title, :english_title

  def id
    object.slug
  end

  def include_english_title?
    object.english_title && object.english_title.strip.length > 0
  end

  def include_romaji_title?
    object.romaji_title && object.romaji_title.strip.length > 0
  end
end
