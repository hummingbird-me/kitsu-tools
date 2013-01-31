class Producer < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged]

  attr_accessible :name

  has_and_belongs_to_many :animes

  validates :name, :slug, :presence => true, :uniqueness => true
end
