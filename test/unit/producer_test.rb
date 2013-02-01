require 'test_helper'

class ProducerTest < ActiveSupport::TestCase
  test "cannot create producer without name" do
    pr = Producer.new
    assert !pr.save
  end

  test "cannot create producer without unique name" do
    pr = Producer.new
    pr.name = "Aniplex"
    assert !pr.save
  end

  test "can retrieve producer using a slug" do
    assert_equal Producer.find("aniplex"), producers(:aniplex)
  end

  test "slug is generated automatically" do
    pr = Producer.new
    pr.name = "Kawaii Productions"
    assert pr.save
    assert_equal pr.slug, "kawaii-productions"
  end
end
