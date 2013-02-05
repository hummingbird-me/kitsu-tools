class Recommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :user_id, :anime_id, :score
end
