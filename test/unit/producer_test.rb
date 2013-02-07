require 'test_helper'

class ProducerTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:animes)
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should validate_presence_of(:slug)

  test "can find producer using a slug" do
    assert_equal Producer.find("aniplex"), producers(:aniplex)
  end
end
