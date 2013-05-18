class Action < ActiveRecord::Base
  belongs_to :user
  attr_accessible :action_type, :data
  serialize :data, ActiveRecord::Coders::Hstore
end
