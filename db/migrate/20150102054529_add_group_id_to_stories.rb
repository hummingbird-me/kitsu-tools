class AddGroupIdToStories < ActiveRecord::Migration
  def change
    change_table :stories do |t|
      t.references :group, index: true
    end
  end
end
