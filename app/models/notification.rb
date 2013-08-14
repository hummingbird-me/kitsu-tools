class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true
  attr_accessible :user, :source, :data, :notification_type
  serialize :data, ActiveRecord::Coders::Hstore
end
