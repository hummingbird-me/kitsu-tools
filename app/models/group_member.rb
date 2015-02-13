# == Schema Information
#
# Table name: group_members
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  group_id   :integer          not null
#  pending    :boolean          default(TRUE), not null
#  created_at :datetime
#  updated_at :datetime
#  rank       :integer          default(0), not null
#

class GroupMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  scope :pending, -> { where(pending: true) }
  scope :accepted, -> { where(pending: false) }

  enum rank: [:pleb, :mod, :admin]

  validates :user_id, uniqueness: {scope: :group_id}

  after_save do
    update_group_scores!
    if pending_changed? && pending == false
      update_counter_cache! +1
    end
  end

  after_destroy do
    update_counter_cache! -1
  end

  def update_counter_cache!(diff)
    # Atomically incr/decr the counter
    Group.update_counters(self.group_id, confirmed_members_count: diff)
  end

  def update_group_scores!
    if self.pending_changed? && self.pending == false
      TrendingGroups.vote(self.group_id)
    end
  end
end
