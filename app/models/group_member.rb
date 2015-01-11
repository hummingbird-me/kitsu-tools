# == Schema Information
#
# Table name: group_members
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  group_id   :integer          not null
#  admin      :boolean          default(FALSE), not null
#  pending    :boolean          default(TRUE), not null
#  created_at :datetime
#  updated_at :datetime
#

class GroupMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  scope :pending, -> { where(pending: true) }
  scope :accepted, -> { where(pending: false) }

  validates_associated :group
  validates :user_id, uniqueness: {scope: :group_id}

  after_save do
    update_group_scores!
    update_counter_cache!
  end

  after_destroy do
    update_counter_cache!
  end

  def update_counter_cache!
    self.group.update_attribute :confirmed_members_count,
                                GroupMember.where(pending: false, group: group).count
  end

  def update_group_scores!
    if self.pending_changed? && self.pending == false
      TrendingGroups.vote(self.group_id)
    end
  end
end
