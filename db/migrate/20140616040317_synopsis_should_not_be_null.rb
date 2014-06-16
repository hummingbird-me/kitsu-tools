class SynopsisShouldNotBeNull < ActiveRecord::Migration
  def change
    change_column :anime, :synopsis, :text, null: false, default: ""
    change_column :manga, :synopsis, :text, null: false, default: ""
  end
end
