class CleanUpCastings < ActiveRecord::Migration
  class Casting < ActiveRecord::Base; end

  def change
    # Castable --> Media
    rename_column :castings, :castable_id, :media_id
    rename_column :castings, :castable_type, :media_type
    # featured -> null: false, default: false
    change_column_default :castings, :featured, false
    change_column_null :castings, :featured, false
    # voice_actor -> null: false, default: false
    change_column_default :castings, :voice_actor, false
    change_column_null :castings, :voice_actor, false

    # Media and Character are mandatory, Person is not (voiceless or manga)
    change_column_null :castings, :media_id, false
    change_column_null :castings, :media_type, false
    change_column_null :castings, :character_id, false

    # If it's an anime, it's a safe bet they're a VA
    Casting.where(media_type: 'Anime').update_all(voice_actor: true)
  end
end
