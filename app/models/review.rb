class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :content, :positive

  validates :user, :anime, :content, :positive, :presence => true

  def negative?
    not positive?
  end
end
