# == Schema Information
#
# Table name: groups
#
#  id                       :integer          not null, primary key
#  name                     :string(255)      not null
#  slug                     :string(255)      not null
#  bio                      :string(255)      default(""), not null
#  about                    :text             default(""), not null
#  avatar_file_name         :string(255)
#  avatar_content_type      :string(255)
#  avatar_file_size         :integer
#  avatar_updated_at        :datetime
#  cover_image_file_name    :string(255)
#  cover_image_content_type :string(255)
#  cover_image_file_size    :integer
#  cover_image_updated_at   :datetime
#  confirmed_members_count  :integer          default(0)
#  created_at               :datetime
#  updated_at               :datetime
#

require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:name).case_insensitive
  should validate_presence_of(:name)

  test "creating new with admin" do
    group = Group.new_with_admin({name: 'Jerks'}, users(:josh))

    assert_equal true, group.valid?, "Group should be valid"
    assert_equal true, group.save, "Group should save properly"
    assert_equal users(:josh).id, group.members.first.user.id, "User should be admin"
  end
end
