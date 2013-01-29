require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "cannot create a person without a name" do
    ps = Person.new
    ps.name = ""
    assert !ps.save
  end
end
