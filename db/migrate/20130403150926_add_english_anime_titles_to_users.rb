class AddEnglishAnimeTitlesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :english_anime_titles, :boolean, default: true
  end
end
