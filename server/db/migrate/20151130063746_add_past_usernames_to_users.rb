class AddPastUsernamesToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :past_names, array: true, default: [], null: false
    end
  end
end
