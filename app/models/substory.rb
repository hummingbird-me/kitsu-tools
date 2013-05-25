class Substory < ActiveRecord::Base
  belongs_to :user
  belongs_to :target
  belongs_to :story
  attr_accessible :substory_type

  validates :user, :target, :substory_type, :story, presence: true
end
