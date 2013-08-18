class Person < ActiveRecord::Base
  attr_accessible :name, :mal_id, :image
  validates :name, :presence => true
  has_many :castings, dependent: :destroy

  has_attached_file :image, 
    styles: {thumb_small: "30x39#"}, 
    default_url: "/assets/default-avatar.jpg",
    convert_options: {all: "-unsharp 2x0.5+1+0"}
end
