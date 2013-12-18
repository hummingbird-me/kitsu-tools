require 'test_helper'

class MangaTest < ActiveSupport::TestCase
  should validate_presence_of(:romaji_title)
end
