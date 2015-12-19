class Drama < ActiveRecord::Base
  include Media
  include AgeRatings
  include Episodic
end
