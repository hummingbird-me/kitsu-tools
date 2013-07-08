class Genre < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged]

  attr_accessible :name, :description
  has_and_belongs_to_many :animes

  validates :name, :slug, :presence => true, :uniqueness => true

  def to_s
    name
  end

  def self.default_filterable(user=nil)
    genres = Genre.all
    if user && user.sfw_filter 
      genres -= Genre.where('slug IN (?)', %w(hentai yaoi yuri shounen-ai shoujo-ai)) 
    end
    genres.sort_by {|x| x.name }
  end
end
