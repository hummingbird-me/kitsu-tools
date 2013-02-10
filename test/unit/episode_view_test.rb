require 'test_helper'

class EpisodeViewTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:anime)
  should belong_to(:episode)

  test "episode anime id should equal anime id" do
    a1 = FactoryGirl.create(:anime)
    a2 = FactoryGirl.create(:anime, title: "asdf 2")
    u  = FactoryGirl.create(:user)
    e  = FactoryGirl.create(:episode, anime: a1)
    ev = EpisodeView.new
    ev.user = u; ev.anime = a2; ev.episode = e
    p ev
    assert !ev.save
    assert ev.errors[:anime].any? {|x| x.include? "identifier does not match episode" }
  end
end
