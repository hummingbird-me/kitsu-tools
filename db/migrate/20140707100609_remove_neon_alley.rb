class RemoveNeonAlley < ActiveRecord::Migration
  def change
    remove_column :users, :neon_alley_integration
  end
end
