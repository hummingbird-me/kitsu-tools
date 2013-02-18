class GalleryImage < ActiveRecord::Base
  belongs_to :anime
  attr_accessible :anime_id, :description, :image
  has_attached_file :image, styles: {thumb: '380x214'}
  validates :anime, :image, presence: true
end
