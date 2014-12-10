# == Schema Information
#
# Table name: versions
#
#  id             :integer          not null, primary key
#  item_id        :integer          not null
#  item_type      :string(255)      not null
#  user_id        :integer
#  object         :json             not null
#  object_changes :json             not null
#  state          :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  comment        :string(255)
#

class VersionTest < ActiveSupport::TestCase
  should validate_presence_of(:item)
  should validate_presence_of(:user)
  should validate_presence_of(:object)
  should validate_presence_of(:object_changes)

  test "can restore to an older version" do
    version = versions(:two)
    initial_count = Version.count
    history_count =
      Version.where(item: version.item, state: Version.states[:history])
        .where("id >= ?", version.id).count

    initial_attrs = version.item.attributes
    version.item.restore_to_version(version)
    updated_attrs = version.item.attributes

    assert_not_equal updated_attrs, initial_attrs
    assert_equal (initial_count - history_count), Version.count
  end
end
