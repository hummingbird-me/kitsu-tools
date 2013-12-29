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
  attr_accessible :role, :type, :anime_id, :person_id, :character_id, :featured, :voice_actor, :order, :language

  def name
    "#{character.try(:name)} ... #{person.try(:name)}"
  end
end
