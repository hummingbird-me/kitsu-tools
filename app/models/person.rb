class Person < ActiveRecord::Base
  attr_accessible :name, :mal_id
  validates :name, :presence => true
  has_attached_file :image, :styles => {:thumb_small => "30x47", :thumb => "225x350"}, 
    :default_url => "/assets/default-avatar.jpg"  
end
