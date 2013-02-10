class AddSfwFilterToUser < ActiveRecord::Migration
  def change
    add_column :users, :sfw_filter, :boolean, default: true
  end
end
