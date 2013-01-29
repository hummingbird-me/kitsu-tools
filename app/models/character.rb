class Character < ActiveRecord::Base
  attr_accessible :description, :name, :voice_actor_id
end
