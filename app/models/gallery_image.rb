class GalleryImage < ActiveRecord::Base
  belongs_to :anime
  attr_accessible :anime_id, :description, :image
  has_attached_file :image

  validates :anime, presence: true
end
