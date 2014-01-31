# == Schema Information
#
# Table name: quotes
#
#  id             :integer          not null, primary key
#  anime_id       :integer
#  content        :text
#  character_name :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  positive_votes :integer          default(0), not null
#

class Quote < ActiveRecord::Base
  attr_accessible :anime_id, :character_name, :content

  belongs_to :anime
  belongs_to :user

  has_many :substories, as: :target, dependent: :destroy

  def creator
    user
  end

  validates :content, :anime, :user, :presence => true
end
