class Quote < ActiveRecord::Base
  attr_accessible :anime_id, :character_name, :content
  belongs_to :anime
  belongs_to :creator, :class_name => "User"

  validates :content, :anime, :creator, :presence => true
end
