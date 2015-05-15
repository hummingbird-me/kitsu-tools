class AddWriteAccessAndVisibilityToApps < ActiveRecord::Migration
  def change
    add_column :apps, :write_access, :boolean, null: false, default: false
    add_column :apps, :public, :boolean, null: false, default: false
  end
end
