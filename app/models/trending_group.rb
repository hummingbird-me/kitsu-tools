class TrendingGroup < ActiveRecord::Base
  self.table_name = 'trending_groups'
  after_initialize :readonly!

  belongs_to :group

  default_scope ->{ order('score DESC').includes(:group) }

  def self.not_joined_by_user(user)
    user = user.id if user.is_a?(User)
    TrendingGroup.where.not(
      group: GroupMember.where(user_id: user).select(:group_id)
    )
  end

  def self.groups
    select(:group_id).map { |x| x.group }
  end
end
