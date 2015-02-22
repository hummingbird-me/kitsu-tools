require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  def setup
    @controller = SearchController.new
  end

  test "can present manga" do
    manga = manga(:monster)
    manga.define_singleton_method(:pg_search_rank) { 0.9 }
    presented = @controller.send(:present_manga, manga)

    assert_includes presented, :image
    assert_equal "manga", presented[:type]
    [:title, :desc, :link].each { |s|
      assert_kind_of String, presented[s]
    }
    assert_kind_of Float, presented[:rank]
    assert_kind_of Array, presented[:badges]
  end

  test "can present anime for a nobody" do
    anime = anime(:sword_art_online)
    anime.define_singleton_method(:pg_search_rank) { 0.9 }
    @controller.define_singleton_method(:current_user) { nil }
    presented = @controller.send(:present_anime, anime)

    assert_kind_of String, presented[:title]
  end

  test "can present anime for a user" do
    anime = anime(:sword_art_online)
    user = users(:josh)
    anime.define_singleton_method(:pg_search_rank) { 0.9 }
    @controller.define_singleton_method(:current_user) { user }
    presented = @controller.send(:present_anime, anime)

    assert_includes presented, :image
    assert_equal "anime", presented[:type]
    [:title, :desc, :link].each { |s|
      assert_kind_of String, presented[s]
    }
    assert_kind_of Float, presented[:rank]
    assert_kind_of Array, presented[:badges]
  end

  test "can present character" do
    character = characters(:kirito)
    character.define_singleton_method(:pg_search_rank) { 0.9 }
    presented = @controller.send(:present_character, character)

    assert_includes presented, :image
    assert_equal "character", presented[:type]
    [:title, :desc, :link].each { |s|
      assert_kind_of String, presented[s]
    }
    assert_kind_of Float, presented[:rank]
    assert_kind_of Array, presented[:badges]
  end

  test "can present group" do
    group = groups(:gumi)
    group.define_singleton_method(:pg_search_rank) { 0.9 }
    presented = @controller.send(:present_group, group)

    assert_includes presented, :image
    assert_equal "group", presented[:type]
    [:title, :desc, :link].each { |s|
      assert_kind_of String, presented[s]
    }
    assert_kind_of Float, presented[:rank]
    assert_kind_of Array, presented[:badges]
  end

  test "can present user" do
    user = users(:josh)
    user.define_singleton_method(:pg_search_rank) { 0.9 }
    presented = @controller.send(:present_user, user)

    assert_includes presented, :image
    assert_equal "user", presented[:type]
    [:title, :desc, :link].each { |s|
      assert_kind_of String, presented[s]
    }
    assert_kind_of Float, presented[:rank]
    assert_kind_of Array, presented[:badges]
  end
end
