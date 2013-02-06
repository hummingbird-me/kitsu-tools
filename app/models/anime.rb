class Anime < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => [:slugged]

  attr_accessible :title, :age_rating, :episode_count, :episode_length, :mal_id, :status, :synopsis, :cover_image
  has_attached_file :cover_image

  has_many :quotes
  has_many :castings
  has_many :reviews
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :producers

  validates :title, :slug, :presence => true, :uniqueness => true
end
