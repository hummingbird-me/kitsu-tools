class CreateCastings < ActiveRecord::Migration
  def change
    create_table :castings do |t|
      t.integer :anime_id
      t.integer :character_id
      t.integer :voice_actor_id

      t.timestamps
    end
  end
end
