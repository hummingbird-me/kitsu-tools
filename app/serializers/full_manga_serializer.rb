class FullMangaSerializer < MangaSerializer
  embed :ids, include: true

  attributes :bayesian_rating,
             :cover_image,
             :cover_image_top_offset,
             :community_ratings,
             :pending_edits

  has_one :manga_library_entry
  has_many :featured_castings, root: :castings

  def manga_library_entry
    scope && MangaLibraryEntry.where(user_id: scope.id, manga_id: object.id).first
  end

  def cover_image
    object.cover_image_file_name ? object.cover_image.url(:thumb) : nil
  end

  def cover_image_top_offset
    object.cover_image_top_offset || 0
  end

  def pending_edits
    scope && Version.pending.where(user: scope, item: object).count
  end

  def featured_castings
    object.castings.where(featured: true).includes(:character).sort_by {|x| x.order || 100 }
  end
end
