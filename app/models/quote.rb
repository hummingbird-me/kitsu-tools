class Quote < ActiveRecord::Base
  attr_accessible :anime_id, :character_id, :content
  belongs_to :anime
  belongs_to :character
end
