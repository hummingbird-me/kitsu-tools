class AddNeonAlleyIntegrationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :neon_alley_integration, :boolean
  end
end
