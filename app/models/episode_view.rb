class EpisodeView < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  belongs_to :episode
  # attr_accessible :title, :body
end
