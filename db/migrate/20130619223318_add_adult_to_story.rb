class AddAdultToStory < ActiveRecord::Migration
  def change
    add_column :stories, :adult, :boolean, default: false
  end
end
