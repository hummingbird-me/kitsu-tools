require 'test_helper'

class ProducerTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should have_and_belong_to_many(:anime)
end
