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

  test "should fail to validate if last admin resigns as admin" do
    vik = group_members(:vikhyat_gumi)
    vik.admin = false

    assert_equal false, vik.valid?, "Should not validate as last admin"
  end

  test "should fail to destroy if last admin leaves group" do
    skip # TODO: make this test pass
    vik = group_members(:vikhyat_gumi)

    assert_equal false, vik.destroy, "Should not destroy"
  end
end
