class Person < ActiveRecord::Base
  attr_accessible :name, :mal_id
  validates :name, :presence => true
  has_attached_file :image, :styles => {:thumb => "225x350"}, 
    :default_url => "http://placekitten.com/225/350"  
end
