class IncreaseAnimeTitleLength < ActiveRecord::Migration
  def change
    change_column :anime, :title, :string, :limit => 500
    change_column :anime, :alt_title, :string, :limit => 500
    change_column :anime, :slug, :string, :limit => 500
  end
end
