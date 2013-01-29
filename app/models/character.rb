class Character < ActiveRecord::Base
  attr_accessible :description, :name, :voice_actor_id
  belongs_to :voice_actor, :class_name => "Person"

  validates :name, :presence => true
end
