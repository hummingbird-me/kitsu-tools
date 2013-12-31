# == Schema Information
#
# Table name: watchlists
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  anime_id         :integer
#  status           :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  episodes_watched :integer          default(0)
#  rating           :decimal(2, 1)
#  last_watched     :datetime
#  imported         :boolean
#  private          :boolean          default(FALSE)
#  notes            :text
#  rewatched_times  :integer          default(0)
#  rewatching       :boolean
#

require 'test_helper'

class LibraryEntryTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:anime)
  should have_many(:stories).dependent(:destroy)
  should validate_presence_of(:user)
  should validate_presence_of(:anime)
  should validate_presence_of(:status)
  should validate_uniqueness_of(:user_id).scoped_to(:anime_id)
  should ensure_inclusion_of(:status).in_array(LibraryEntry::VALID_STATUSES)

  test "should track number of users with library entry for a show" do
    anime = Anime.find('monster')
    original_user_count = anime.user_count
    entry = LibraryEntry.create!(anime_id: anime.id,
                                 user_id: users(:vikhyat).id,
                                 status: "Plan to Watch")
    assert_equal original_user_count+1, anime.reload.user_count
    entry.destroy
    assert_equal original_user_count, anime.reload.user_count
  end
end
