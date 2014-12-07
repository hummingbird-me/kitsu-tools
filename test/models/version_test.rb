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
end
