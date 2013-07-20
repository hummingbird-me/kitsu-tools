class ConsistentAiringStatuses < ActiveRecord::Migration
  def up
    Anime.find_each do |anime|
      if anime.status == "Not yet aired"
        anime.update_column :status, "Not Yet Aired"
      end
    end
  end

  def down
  end
end
