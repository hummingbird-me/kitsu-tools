# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: genres
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# rubocop:enable Metrics/LineLength

class Genre < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders history]
  resourcify

  has_and_belongs_to_many :anime
  has_and_belongs_to_many :manga
end
