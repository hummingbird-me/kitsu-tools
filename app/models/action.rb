class Action < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore
end
