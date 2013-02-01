class AddCreatorToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :creator_id, :integer
  end
end
