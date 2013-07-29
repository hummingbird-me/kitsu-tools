class Casting < ActiveRecord::Base
  belongs_to :anime
  belongs_to :person
  belongs_to :character
  attr_accessible :role, :type, :anime_id, :person_id, :character_id

  def name
    "#{character.try(:name)} ... #{person.try(:name)}"
  end
end
