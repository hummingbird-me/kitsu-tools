
class VoiceActorsLanguageFromRole < ActiveRecord::Migration
  def up
    languages = ["Brazilian", "English", "French", "German", "Hebrew", "Hungarian", "Italian", "Japanese", "Korean", "Spanish"]
    Casting.where(role: languages).find_each do |casting|
      casting.update_attributes role: "Voice Actor", language: casting.role
    end
  end

  def down
    languages = ["Brazilian", "English", "French", "German", "Hebrew", "Hungarian", "Italian", "Japanese", "Korean", "Spanish"]
    Casting.where('language IS NOT NULL').find_each do |casting|
      casting.update_attributes role: casting.language, language: nil
    end
  end
end

