class DefaultLifeSpentOnAnimeToZero < ActiveRecord::Migration
  def up
    User.where(life_spent_on_anime: nil).update_all life_spent_on_anime: 0
    change_column :users, :life_spent_on_anime, :integer, null: false, default: 0
  end

  def down
    change_column :users, :life_spent_on_anime, :integer
  end
end
