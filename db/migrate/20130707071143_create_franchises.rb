class CreateFranchises < ActiveRecord::Migration
  def change
    create_table :franchises do |t|
      t.string :title
      t.timestamps
    end

    create_table :anime_franchises, id: false do |t|
      t.belongs_to :anime
      t.belongs_to :franchise
    end
  end
end
