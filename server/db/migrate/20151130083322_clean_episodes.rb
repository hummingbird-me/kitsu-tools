class CleanEpisodes < ActiveRecord::Migration
  class Episode < ActiveRecord::Base
    belongs_to :anime
  end

  def change
    # Add per-episode length
    add_column :episodes, :length, :integer

    # Switch to Titleable concern
    add_column :episodes, :titles, :hstore, default: '', null: false
    add_column :episodes, :canonical_title, :string, null: false, default: 'ja_en'
    execute <<-SQL
      UPDATE episodes
      SET titles = hstore(ARRAY['ja_en'], ARRAY[title])
    SQL
    remove_column :episodes, :title
  end
end
