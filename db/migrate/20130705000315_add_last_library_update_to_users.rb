class AddLastLibraryUpdateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_library_update, :datetime
  end
end
