class GalleryImage < ActiveRecord::Base
  belongs_to :anime
  attr_accessible :description
end
