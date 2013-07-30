class GalleryImage < ActiveRecord::Base
  belongs_to :anime
  attr_accessible :anime_id, :description, :image
  validates :anime, :image, presence: true

  has_attached_file :image, 
    styles: {thumb: '265x144'},
    convert_options: {thumb: '-unsharp 2x0.5+1+0'},
    storage: :s3,
    s3_credentials: {
      bucket: ENV['AWS_BUCKET'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    url: ':s3_domain_url',
    path: '/:class/:attachment/:id_partition/:style/:filename'
end
