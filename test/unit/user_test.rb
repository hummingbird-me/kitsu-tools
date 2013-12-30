require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_can_search_by_name_and_email
    assert User.search('vik').include?(users(:vikhyat))
    assert User.search('vikhyat').include?(users(:vikhyat))
    assert !User.search('vikhyatsdaf').include?(users(:vikhyat))
    assert User.search('c@vikhyat').include?(users(:vikhyat))
    assert User.search('c@vikhyat.net').include?(users(:vikhyat))
  end
end
