class RemoveFaunaRatings < ActiveRecord::Migration
  def round(n)
    rounded = (n / 0.5).round * 0.5
    rounded = 0.5 if rounded < 0.5
    rounded = 5.0 if rounded > 5.0
    rounded
  end

  def change
    remove_column :users, :fauna_rating, :boolean, default: true

    MangaLibraryEntry.transaction do
      MangaLibraryEntry.where.not(rating: (0..5).step(0.5).to_a).find_each do |entry|
        entry.update_columns rating: round(entry.rating)
      end
      LibraryEntry.where.not(rating: (0..5).step(0.5).to_a).find_each do |entry|
          entry.update_columns rating: round(entry.rating)
      end
    end

    change_column :manga_library_entries, :rating, :decimal,
      precision: 2, scale: 1
    change_column :watchlists, :rating, :decimal,
      precision: 2, scale: 1
  end
end
