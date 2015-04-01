class AddFaunaRatingSystem < ActiveRecord::Migration
  def change
    # Add a column for fauna rating
    add_column :users, :fauna_rating, :boolean, default: true

    # Add more precision to handle the 73-point ratings
    change_column :manga_library_entries, :rating, :decimal,
      precision: 4, scale: 3
    change_column :watchlists, :rating, :decimal,
      precision: 4, scale: 3
  end
end
