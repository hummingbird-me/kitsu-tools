class RemoveSlugFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :slug
  end

  def down
    add_column :users, :slug, :string
  end
end
