require 'test_helper'

class EpisodeViewTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:anime)
  should belong_to(:episode)
end
