class Anime < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => [:slugged]

  attr_accessible :title, :age_rating, :episode_count, :episode_length, :mal_id, :status, :synopsis

  has_many :quotes
  has_many :castings

  validates :title, :slug, :presence => true

  # Return the URL to the anime cover image.
  # At a later stage it might be useful to make this a column in the database.
  def cover_image_url
    "http://vikhyat.net/AnimeGraph/thumbs/#{mal_id}.jpg"
  end
end
