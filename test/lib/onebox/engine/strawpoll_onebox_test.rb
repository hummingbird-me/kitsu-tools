require 'test_helper'
require 'onebox/engine/strawpoll_onebox'

class StrawpollOneboxTest < ActiveSupport::TestCase
  test "gets the poll id from the URL" do
    obj = Onebox::Engine::StrawpollOnebox.new("http://strawpoll.me/5456388")
    assert_equal '5456388', obj.poll_id
  end

  test "embeds strawpoll poll" do
    assert_match /iframe/, Onebox.preview("http://strawpoll.me/5456388").to_s
    assert_match /iframe/, Onebox.preview("https://strawpoll.me/5456388").to_s
  end
end
