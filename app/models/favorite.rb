class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, polymorphic: true

  attr_accessible :user, :item
end
