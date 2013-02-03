class Watchlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :positive, :status
end
