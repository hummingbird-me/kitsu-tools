class Casting < ActiveRecord::Base
  belongs_to :media, polymorphic: true, touch: true
  belongs_to :character, touch: true

  validates :media, presence: true
  validates :character, presence: true
end
