class AddVolumesAndChaptersToManga < ActiveRecord::Migration
  def change
    add_column :manga, :volume_count, :integer
    add_column :manga, :chapter_count, :integer
  end
end
