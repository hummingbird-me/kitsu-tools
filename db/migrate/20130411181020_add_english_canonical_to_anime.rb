class AddEnglishCanonicalToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :english_canonical, :boolean, default: false
  end
end
