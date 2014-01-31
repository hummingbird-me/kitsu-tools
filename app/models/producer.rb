# == Schema Information
#
# Table name: producers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Producer < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :history]

  attr_accessible :name
  has_and_belongs_to_many :anime

  validates :name, presence: true, uniqueness: true
end
