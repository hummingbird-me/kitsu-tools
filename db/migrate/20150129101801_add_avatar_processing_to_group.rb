class AddAvatarProcessingToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :avatar_processing, :boolean
  end
end
