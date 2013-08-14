class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source
  attr_accessible :data
  serialize :data, ActiveRecord::Coders::Hstore
end
