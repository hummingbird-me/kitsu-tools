require 'test_helper'

class NewsFeedTest < ActiveSupport::TestCase
  test "it gets active joined groups" do
    feed = NewsFeed.new(users(:vikhyat))
    groups = feed.active_joined_groups.map(&:slug)
    assert_includes groups, 'gumi-appreciation-group'
    assert_includes groups, 'jerks'
  end
end
