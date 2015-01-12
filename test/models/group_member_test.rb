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

require 'test_helper'

class GroupMemberTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:user_id).scoped_to(:group_id)
end
