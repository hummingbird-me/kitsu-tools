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
    genre_slugs = %w(action romance fantasy adventure comedy sci-fi mystery magic
                     supernatural shounen sports josei slice-of-life seinen horror
                     pyschological thriller ecchi mecha shoujo kids)
    genre_slugs += %w(hentai yaoi yuri) if user && !user.sfw_filter
    Genre.where('slug IN (?)', genre_slugs).order(:name)
  end
end
