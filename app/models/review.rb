class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :content, :positive
end
