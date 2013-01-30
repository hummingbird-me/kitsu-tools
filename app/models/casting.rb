class Casting < ActiveRecord::Base
  attr_accessible :anime_id, :character_id, :voice_actor_id
  belongs_to :anime
  belongs_to :character
  belongs_to :voice_actor, :class_name => "Person"

  validates :anime, :character, :presence => true
end
