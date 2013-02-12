class AddVoiceActorToCasting < ActiveRecord::Migration
  def change
    add_column :castings, :voice_actor, :boolean
  end
end
