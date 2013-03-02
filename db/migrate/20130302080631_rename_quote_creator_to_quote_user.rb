class RenameQuoteCreatorToQuoteUser < ActiveRecord::Migration
  def change
    rename_column :quotes, :creator_id, :user_id
  end
end
