# == Schema Information
#
# Table name: recommendations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  recommendations :hstore
#

class Recommendation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id
  
  serialize :recommendations, ActiveRecord::Coders::Hstore
end
