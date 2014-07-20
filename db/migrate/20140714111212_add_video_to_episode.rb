class AddVideoToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :synopsis, :text
    add_attachment :episodes, :thumbnail
  end
end
