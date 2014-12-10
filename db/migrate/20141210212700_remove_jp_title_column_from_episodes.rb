class RemoveJpTitleColumnFromEpisodes < ActiveRecord::Migration
  def change
    remove_column :episodes, :jp_title, :text
  end
end
