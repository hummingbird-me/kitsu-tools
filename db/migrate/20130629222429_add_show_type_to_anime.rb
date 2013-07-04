class AddShowTypeToAnime < ActiveRecord::Migration
  def up
    add_column :anime, :show_type, :string
    
    Anime.find_each do |anime|
      if anime.title.include? "OVA" or (anime.alt_title and anime.alt_title.include?("OVA"))
        anime.update_column :show_type, "OVA"
      elsif anime.title.include? "ONA" or (anime.alt_title and anime.alt_title.include?("ONA"))
        anime.update_column :show_type, "ONA"
      elsif anime.episode_count == 1
        anime.update_column :show_type, "Movie"
      else
        anime.update_column :show_type, "TV"
      end
    end
  end
  
  def down
    remove_column :anime, :show_type
  end
end
