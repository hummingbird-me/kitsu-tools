class Person < ActiveRecord::Base
  attr_accessible :name, :mal_id
  validates :name, :presence => true
  has_many :castings, dependent: :destroy

  has_attached_file :image, 
    styles: {thumb_small: "30x39#"}, 
    default_url: "/assets/default-avatar.jpg",
    convert_options: {all: "-unsharp 2x0.5+1+0"},
    storage: :s3,
    s3_credentials: {
      bucket: ENV['AWS_BUCKET'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    url: ':s3_domain_url'
end
