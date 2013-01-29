class Anime < ActiveRecord::Base
  attr_accessible :age_rating, :episode_count, :episode_length, :mal_id, :status, :synopsis
end
