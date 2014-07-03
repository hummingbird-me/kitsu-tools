# == Schema Information
#
# Table name: castings
#
#  id            :integer          not null, primary key
#  castable_id   :integer
#  person_id     :integer
#  character_id  :integer
#  role          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  voice_actor   :boolean
#  featured      :boolean
#  order         :integer
#  language      :string(255)
#  castable_type :string(255)
#

class Casting < ActiveRecord::Base
  belongs_to :castable, polymorphic: true
  belongs_to :person
  belongs_to :character

  def name
    "#{character.try(:name)} ... #{person.try(:name)}"
  end

  # for voice actors:
  #   { mal_id: 1234,
  #     name: "Butt Chuggins",
  #     character: #<Character>,
  #     anime: #<Anime>,
  #     featured: true,
  #     lang: "English" }
  # for staff:
  #   { external_id: 1234,
  #     name: "Butt Chuggins",
  #     anime: #<Anime>,
  #     featured: true,
  #     role: "Director" }
  def self.create_or_update_from_hash(hash)
    person = Person.create_or_update_from_hash(hash) unless hash[:name].blank?

    if hash[:character] ### Voice Actor
      # TODO: overwrite castings when adding the first voice actor if there's already a casting
      casting = Casting.find_or_initialize_by({
        language: hash[:lang],
        character: hash[:character],
        castable: hash[:castable]
      })
      casting.person = person
      casting.role = 'Voice Actor' unless person.nil?
    else ### Staff
      casting = Casting.find_or_initialize_by({
        person: person,
        role: hash[:role],
        castable: hash[:castable]
      })
    end
    casting.featured = hash[:featured] if casting.featured.blank?
    casting.save!
    casting
  end
end
