class GalleryImage < ActiveRecord::Base
  belongs_to :anime
  attr_accessible :anime_id, :description, :image
  validates :anime, :image, presence: true

  has_attached_file :image, 
    styles: {thumb: '265x144'},
    convert_options: {thumb: '-unsharp 2x0.5+1+0'}
end
