class Quote < ActiveRecord::Base
  attr_accessible :anime_id, :character_name, :content
  belongs_to :anime

  validates :content, :anime, :presence => true
end
