class AddStatusToManga < ActiveRecord::Migration
  def change
    add_column :manga, :status, :string
  end
end
