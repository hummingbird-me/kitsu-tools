class Genre < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged]

  attr_accessible :name, :description
  has_and_belongs_to_many :animes

  validates :name, :slug, :presence => true, :uniqueness => true

  def to_s
    name
  end

  def self.nsfw_slugs
    %w(hentai yaoi yuri shounen-ai shoujo-ai)
  end

  def nsfw?
    Genre.nsfw_slugs.include? self.slug
  end

  def sfw?
    not nsfw?
  end

  def self.default_filterable(user=nil)
    if user.nil? or user.sfw_filter
      Genre.order(:name).where('slug NOT IN (?)', Genre.nsfw_slugs).all
    else
      Genre.order(:name).all
    end
  end
end
