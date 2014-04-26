# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  item_type  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fav_rank   :integer		
#
class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, polymorphic: true

  attr_accessible :user, :item, :fav_rank
end
