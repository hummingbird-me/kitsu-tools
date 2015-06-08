require 'test_helper'

class Api::V2::AnimeControllerTest < ActionController::TestCase
  setup do
    @controller.class.skip_before_filter :require_client_id
    # Mind the fixture data generated on anime.yml until we get rid of it
    create(:anime, title: 'Anime name1', show_type: 'OVA', age_rating: 'PG',
                   episode_count: '3', started_airing_date: '2011-06-01',
                   finished_airing_date: '2011-09-01')
    create(:anime, title: 'Anime name2', started_airing_date: '2011-05-01')
  end

  #TODO test json structure
  test "can list anime" do
    get :index
    assert_response 200
    assert JSON.parse(@response.body)['anime'].is_a? Array
  end

  test "can search anime by name" do
    get :index, filter: { name: 'by name' }
    anime = get_anime_from_body
    assert_equal 2, anime.length
    assert_equal 'Anime name1', anime.first['canonical_title']
    assert_equal 'Anime name2', anime.last['canonical_title']
  end

  test "can search anime by id" do
    get :index, filter: { id: 'anime-name1' }
    anime = get_anime_from_body
    assert_equal 1, anime.length
    assert_equal 'anime-name1', anime.first['id']
  end

  test "can search anime by show_type" do
    get :index, filter: { show_type: 'OVA' }
    anime = get_anime_from_body
    assert_equal 1, anime.length
    assert_equal 'OVA', anime.first['show_type']
  end

  test "can search anime by age rating" do
    get :index, filter: { age_rating: 'PG' }
    anime = get_anime_from_body
    assert_equal 1, anime.length
    assert_equal 'PG', anime.first['age_rating']
  end

  test "can search anime by episode count" do
    get :index, filter: { episode_count: '3' }
    anime = get_anime_from_body
    assert_equal 1, anime.length
    assert_equal 3, anime.first['episode_count']
  end

  test "can search anime by started airing" do
    get :index, filter: { started_airing: '2012-05-01' }
    anime = get_anime_from_body
    assert_equal 1, anime.length
    assert_equal '2012-07-08', anime.first['started_airing']
  end

  test "can search anime by finished airing" do
    get :index, filter: { finished_airing: '2006-01-01' }
    anime = get_anime_from_body
    assert_equal 1, anime.length
    assert_equal '2005-09-28', anime.first['finished_airing']
  end

  # test "can search anime by genre" do
  #   get :index, filter: { genres: 'Test' }
  #   anime = get_anime_from_body
  #   assert_equal 1, anime.length
  #   assert_equal 'Test', anime.genres.first['name']
  # end

  test "can search anime by season" do
    get :index, filter: { season: 'summer' }
    anime = get_anime_from_body
    assert_equal 2, anime.length
    assert_equal '2012-07-08', anime.first['started_airing']
  end

  test "can search anime by year" do
    get :index, filter: { year: '2011' }
    anime = get_anime_from_body
    assert_equal 3, anime.length
    assert_equal '2011-04-06', anime.first['started_airing']
  end

  test "can search anime by multiple filters" do
    get :index, filter: { year: '2011', season: 'spring' }
    anime = get_anime_from_body
    assert_equal 2, anime.length
    assert_equal '2011-04-06', anime.first['started_airing']
  end

  test "can get anime" do
    get :show, id: anime(:sword_art_online).id
    assert_response 200
  end

  test "can multi-get anime" do
    get :show, id: [anime(:sword_art_online).id, anime(:monster).id].join(',')
    assert_response 200
    assert JSON.parse(@response.body)["anime"].is_a? Array
    assert_equal 2, JSON.parse(@response.body)["anime"].length
  end

  test "multi-get ignores not found errors" do
    get :show, id: [anime(:sword_art_online).id, "fake-id"].join(',')
    assert_response 200
    assert JSON.parse(@response.body)["anime"].is_a? Array
    assert_equal 1, JSON.parse(@response.body)["anime"].length
  end

  def get_anime_from_body
    anime = JSON.parse(@response.body)['anime']
    assert anime.is_a? Array
    anime
  end
end
