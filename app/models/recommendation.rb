class Recommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :score
end
