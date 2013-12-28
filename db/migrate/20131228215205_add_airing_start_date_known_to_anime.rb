class AddAiringStartDateKnownToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :started_airing_date_known, :boolean, default: true
  end
end
