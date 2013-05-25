class AddDataToSubstory < ActiveRecord::Migration
  def change
    add_column :substories, :data, :hstore
  end
end
