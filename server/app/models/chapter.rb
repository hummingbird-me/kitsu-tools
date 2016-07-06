class Chapter < ActiveRecord::Base
  belongs_to :manga

  validates :manga, presence: true
  validates :number, presence: true

end
