# == Schema Information
#
# Table name: gallery_images
#
#  id                 :integer          not null, primary key
#  anime_id           :integer
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class GalleryImage < ActiveRecord::Base
  belongs_to :anime
  attr_accessible :anime_id, :description, :image
  validates :anime, :image, presence: true

  has_attached_file :image, 
    styles: {thumb: '265x'},
    convert_options: {thumb: '-unsharp 2x0.5+1+0'}
end
