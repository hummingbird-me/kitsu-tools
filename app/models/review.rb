# == Schema Information
#
# Table name: reviews
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  anime_id         :integer
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  rating           :integer
#  source           :string(255)
#  rating_story     :integer
#  rating_animation :integer
#  rating_sound     :integer
#  rating_character :integer
#  rating_enjoyment :integer
#  summary          :string(255)
#  wilson_score     :float            default(0.0)
#  positive_votes   :integer          default(0)
#  total_votes      :integer          default(0)
#

require 'wilson_score'

class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :content, :user, :anime, :source, :rating, :rating_animation, :rating_sound, :rating_character, :rating_enjoyment, :rating_story, :summary

  validates :user, :anime, :content, :rating, :rating_animation, :rating_sound, :rating_character, :rating_enjoyment, :rating_story, presence: true

  # Don't allow a user to review an anime more than once.
  validates :user_id, :uniqueness => {:scope => :anime_id}

  def update_wilson_score!
    positive = self.positive_votes
    total = self.total_votes
    self.update_column :wilson_score, WilsonScore.lower_bound(positive, total)
  end
end
