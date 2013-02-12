class AddMalIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :mal_id, :integer
  end
end
