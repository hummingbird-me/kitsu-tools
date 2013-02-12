class Casting < ActiveRecord::Base
  belongs_to :anime
  belongs_to :person
  belongs_to :character
  attr_accessible :role, :type
end
