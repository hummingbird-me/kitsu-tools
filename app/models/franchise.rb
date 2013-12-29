# == Schema Information
#
# Table name: franchises
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  english_title :string(255)
#  romaji_title  :string(255)
#

class Franchise < ActiveRecord::Base
  attr_accessible :english_title, :romaji_title, :anime_ids
  has_and_belongs_to_many :anime

  def title
    english_title || romaji_title
  end
end
