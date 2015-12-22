class CleanUpCastings < ActiveRecord::Migration
  class Casting < ActiveRecord::Base; end

  def change
    # Castable --> Media
    rename_column :castings, :castable_id, :media_id
    rename_column :castings, :castable_type, :media_type
    # featured -> null: false, default: false
    change_column_default :castings, :featured, false
    change_column_null :castings, :featured, false, false
    # voice_actor -> null: false, default: false
    change_column_default :castings, :voice_actor, false
    change_column_null :castings, :voice_actor, false, false

    # Media is mandatory, Person and Character are not (manga and director)
    Casting.delete_all(media_id: nil)
    change_column_null :castings, :media_id, false
    change_column_null :castings, :media_type, false

    # If it's an anime and there's a character, it's a safe bet they're a VA
    Casting.where(media_type: 'Anime').where.not(character_id: nil)
      .update_all(voice_actor: true)
  end
end
