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
#  episodes_watched :integer          default(0), not null
#  rating           :decimal(2, 1)
#  last_watched     :datetime
#  imported         :boolean
#  private          :boolean          default(FALSE)
#  notes            :text
#  rewatch_count    :integer          default(0), not null
#  rewatching       :boolean          default(FALSE), not null
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

  test "should track ratings" do
    anime = Anime.find('monster')
    nil_count = anime.rating_frequencies["nil"].to_i || 0
    one_count = anime.rating_frequencies["1.0"].to_i || 0
    two_count = anime.rating_frequencies["2.0"].to_i || 0
    entry = LibraryEntry.create!(anime_id: anime.id,
                                 user_id: users(:vikhyat).id,
                                 status: "Currently Watching")
    assert_equal nil_count+1, anime.reload.rating_frequencies["nil"].to_i
    entry.update_attributes(rating: 1)
    assert_equal nil_count, anime.reload.rating_frequencies["nil"].to_i
    assert_equal one_count+1, anime.reload.rating_frequencies["1.0"].to_i
    entry.update_attributes(rating: 2)
    assert_equal one_count, anime.reload.rating_frequencies["1.0"].to_i
    assert_equal two_count+1, anime.reload.rating_frequencies["2.0"].to_i
    entry.destroy
    assert_equal nil_count, anime.reload.rating_frequencies["nil"].to_i
    assert_equal one_count, anime.reload.rating_frequencies["1.0"].to_i
    assert_equal two_count, anime.reload.rating_frequencies["2.0"].to_i
  end

  test "accepts only valid ratings" do
    entry = LibraryEntry.first
    [-1, 0, 0.1].each do |i|
      entry.rating = i
      assert !entry.valid?, "#{i} is invalid"
    end
    [0.5, nil, 5].each do |i|
      entry.rating = i
      assert entry.valid?, "#{i} is valid"
    end
  end

  test "updating episodes watched also updates user's life spent on anime" do
    initial = users(:vikhyat).life_spent_on_anime
    entry = LibraryEntry.first
    entry.episodes_watched += 1
    entry.save
    assert_equal initial+entry.anime.episode_length, User.find('vikhyat').life_spent_on_anime
  end

  test "creating new library entry counts life spent on anime" do
    initial = users(:vikhyat).life_spent_on_anime
    anime = Anime.find('monster')
    entry = LibraryEntry.create!(anime_id: anime.id,
                                 user_id: users(:vikhyat).id,
                                 status: "Currently Watching",
                                 episodes_watched: 3)
    assert_equal initial+3*entry.anime.episode_length, User.find('vikhyat').life_spent_on_anime
  end

  test "removing library entry subtracts time from life spent on anime" do
    initial = users(:vikhyat).life_spent_on_anime
    entry = LibraryEntry.first
    entry.episodes_watched += 1
    entry.save
    assert_equal initial+entry.anime.episode_length, User.find('vikhyat').reload.life_spent_on_anime
    entry.destroy
    assert_equal initial, User.find('vikhyat').reload.life_spent_on_anime
  end

  test "rewatches count towards life spent on anime" do
    user = User.find('vikhyat')

    entry = LibraryEntry.first
    entry.episodes_watched = entry.anime.episode_count
    entry.status = "Completed"
    entry.save
    initial = user.reload.life_spent_on_anime

    # Start rewatching.
    entry.status = "Currently Watching"
    entry.rewatching = true
    entry.episodes_watched = 0
    entry.save

    assert_equal initial, user.reload.life_spent_on_anime

    # Finish rewatching.
    entry.episodes_watched = entry.anime.episode_count
    entry.status = "Completed"
    entry.save

    assert !entry.rewatching
    initial = initial + entry.anime.episode_length * entry.anime.episode_count
    assert_equal initial, user.reload.life_spent_on_anime
    assert_equal 1, entry.rewatch_count

    # Manually set rewatched times.
    entry.rewatch_count = 2
    entry.save
    initial = initial + entry.anime.episode_length * entry.anime.episode_count
    assert_equal initial, user.reload.life_spent_on_anime
  end

  test "should not allow exceeding total number of episodes" do
    entry = LibraryEntry.first
    entry.episodes_watched = entry.anime.episode_count
    entry.save
    entry.episodes_watched = entry.anime.episode_count + 1
    entry.save
    assert_equal entry.anime.episode_count, entry.reload.episodes_watched
  end
end
