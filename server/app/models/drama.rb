class Drama < ActiveRecord::Base
  include Media
  include AgeRatings
end
