class RemoveDumbEnglishAnimeTitlesFieldFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :english_anime_titles
  end
end
