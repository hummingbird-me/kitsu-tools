# == Schema Information
#
# Table name: apps
#
#  id         :integer          not null, primary key
#  creator_id :integer          not null
#  key        :string(255)      not null
#  secret     :string(255)      not null
#  name       :string(255)      not null
#

class App < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'

  validates :creator, presence: true
  validates :name, presence: true, uniqueness: true
  validates :key, uniqueness: true

  before_create do
    self.key = SecureRandom.hex(10)
    self.secret = SecureRandom.base64(30)
  end
end
