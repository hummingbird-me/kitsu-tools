# == Schema Information
#
# Table name: not_interesteds
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  media_id   :integer
#  media_type :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NotInterested < ActiveRecord::Base
  belongs_to :user
  belongs_to :media, polymorphic: true
  
  after_save do
    self.user.update_column :last_library_update, Time.now
  end
end
