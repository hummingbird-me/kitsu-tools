# == Schema Information
#
# Table name: castings
#
#  id           :integer          not null, primary key
#  anime_id     :integer
#  person_id    :integer
#  character_id :integer
#  role         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  voice_actor  :boolean
#  featured     :boolean
#  order        :integer
#  language     :string(255)
#

class Casting < ActiveRecord::Base
  belongs_to :anime
  belongs_to :person
  belongs_to :character
  attr_accessible :role, :type, :anime_id, :person_id, :character_id, :featured, :voice_actor, :order, :language, :person, :anime, :character

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
    person = Person.create_or_update_from_hash(hash)

    if hash[:character] ### Voice Actor
      casting = Casting.find_or_initialize_by({
        person: person,
        language: hash[:lang],
        character: hash[:character],
        anime: hash[:anime]
      })
      casting.role = 'Voice Actor'
    else ### Staff
      casting = Casting.find_or_initialize_by({
        person: person,
        role: hash[:role],
        anime: hash[:anime]
      })
    end
    casting.featured = hash[:featured] if casting.featured.nil?
    casting.save!
    casting
  end
end
