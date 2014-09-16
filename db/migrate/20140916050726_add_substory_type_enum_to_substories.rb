class AddSubstoryTypeEnumToSubstories < ActiveRecord::Migration
  def up
    rename_column :substories, :substory_type, :substory_type_old
    add_column :substories, :substory_type, :integer, default: 0, null: false

    [:followed, :watchlist_status_update, :comment, :watched_episode, :reply].each do |type|
      Substory.where(substory_type_old: type.to_s).update_all substory_type: Substory.substory_types[type]
    end
  end

  def down
    remove_column :substories, :substory_type
    rename_column :substories, :substory_type_old, :substory_type
  end
end
