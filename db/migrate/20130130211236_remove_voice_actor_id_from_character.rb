class RemoveVoiceActorIdFromCharacter < ActiveRecord::Migration
  def up
    remove_column :characters, :voice_actor_id
  end

  def down
    add_column :characters, :voice_actor_id, :integer
  end
end
