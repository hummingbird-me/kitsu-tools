class Anime < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => [:slugged]

  attr_accessible :title, :age_rating, :episode_count, :episode_length, :mal_id, :status, :synopsis

  validates :title, :slug, :presence => true
end
