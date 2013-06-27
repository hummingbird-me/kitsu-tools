class Recommendation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id
  
  serialize :recommendations, ActiveRecord::Coders::Hstore
end
