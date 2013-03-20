class AddSeasonNumberToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :season_number, :integer
  end
end
