# == Schema Information
#
# Table name: genres
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

class Genre < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name, :description
  has_and_belongs_to_many :anime

  validates :name, :slug, :presence => true, :uniqueness => true

  def to_s
    name
  end

  def self.nsfw_slugs
    %w(hentai yaoi yuri)
  end

  def nsfw?
    Genre.nsfw_slugs.include? self.slug
  end

  def sfw?
    not nsfw?
  end

  def self.default_filterable(user=nil)
    if user.nil? or user.sfw_filter
      Genre.order(:name).where('slug NOT IN (?)', Genre.nsfw_slugs)
    else
      Genre.order(:name)
    end
  end
end
