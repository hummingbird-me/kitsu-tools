class Franchise < ActiveRecord::Base
  attr_accessible :english_title, :romaji_title, :anime_ids
  has_and_belongs_to_many :anime

  def title
    english_title || romaji_title
  end
end
