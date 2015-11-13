require 'test_helper'

require 'mal_import'

class MALImportTest < ActiveSupport::TestCase
  def mal
    "http://myanimelist.net"
  end

  def fake_image_urls
    fake_request [:get, %r|http://cdn.myanimelist.net/images/.*|] => "blank_png"
  end

  def fake_character_urls
    fake_requests({
      [:get, "#{mal}/character/11"] => "mal_character_11",
      [:get, "#{mal}/character/36765"] => "mal_character_36765",
      [:get, "#{mal}/character/43892"] => "mal_character_43892"
    })
  end

  ### MANGA
  def fake_manga_urls
    fake_image_urls
    fake_character_urls
    fake_requests({
      [:get, "#{mal}/manga/25/"] => "mal_manga_25_metadata",
      [:get, "#{mal}/manga/25/*/characters"] => "mal_manga_25_characters",
    })
  end

  test "can get manga metadata" do
    fake_manga_urls
    malware = MALImport.new(:manga, 25).metadata
    assert_equal 25, malware[:external_id]
    assert_equal "Fullmetal Alchemist", malware[:title][:canonical]
    assert_equal "鋼の錬金術師", malware[:title][:ja_jp]
    assert_equal 116, malware[:chapter_count]
    assert_equal 27, malware[:volume_count]
    assert_equal "Manga", malware[:type]
    assert_equal "Finished", malware[:status]
    assert_not_nil malware[:serialization]
    assert_instance_of URI::HTTP, malware[:poster_image]
    malware[:dates].each { |date| assert_instance_of Date, date }
  end

  test "can get manga characters" do
    fake_manga_urls
    chars = MALImport.new(:manga, 25).characters
    assert_not_nil chars
    assert_not chars.empty?
    assert chars.select { |c| c[:name].include?(",") }.length == 0,
           "Found a name that wasn't flipped"
  end

  test "can get manga character's info" do
    fake_manga_urls
    chars = MALImport.new(:manga, 25).characters
    ed = chars.select { |c| c[:name] == "Edward Elric" }[0]
    assert_not ed[:description].empty?
    assert_equal ed[:name], "Edward Elric"
    assert_equal ed[:role], "Main"
    assert_equal ed[:external_id], 11
  end

  test "can get manga staff" do
    fake_manga_urls
    staff = MALImport.new(:manga, 25).staff
    assert_not_nil staff
    assert_not staff.empty?
    assert staff.select { |c| c[:name].include?(",") }.length == 0,
           "Found a name that wasn't flipped"
  end

  test "can get manga staff's info" do
    fake_manga_urls
    staff = MALImport.new(:manga, 25).staff
    hiromu = staff.select { |c| c[:name] == "Hiromu Arakawa" }[0]
    assert_equal "Hiromu Arakawa", hiromu[:name]
    assert_equal "Story & Art", hiromu[:role]
    assert_equal 1874, hiromu[:external_id]
  end

  ### ANIME
  def fake_anime_urls
    fake_image_urls
    fake_character_urls
    fake_requests({
      [:get, "#{mal}/anime/11757/"] => "mal_anime_11757_metadata",
      [:get, "#{mal}/anime/11757/*/characters"] => "mal_anime_11757_characters",
    })
  end

  test "can get anime metadata" do
    fake_anime_urls
    malware = MALImport.new(:anime, 11757).metadata
    assert_equal 11757, malware[:external_id]
    assert_equal "Sword Art Online", malware[:title][:canonical]
    assert_nil malware[:title][:en_us]
    assert_equal "ソードアート・オンライン", malware[:title][:ja_jp]
    assert_equal 25, malware[:episode_count]
    assert_equal "TV", malware[:type]
    assert_equal "Finished Airing", malware[:status]
    assert_not malware[:producers].empty?
    assert_instance_of URI::HTTP, malware[:poster_image]
    malware[:dates].each { |date| assert_instance_of Date, date }
  end

  test "can get anime characters" do
    fake_anime_urls
    chars = MALImport.new(:anime, 11757).characters
    assert_not_nil chars
    assert_not chars.empty?
    assert chars.select { |c| c[:name].include?(",") }.length == 0,
           "Found a name that wasn't flipped"
  end

  test "can get anime character's info" do
    fake_anime_urls
    chars = MALImport.new(:anime, 11757).characters
    kirito = chars.select { |c| c[:name] == "Kazuto Kirigaya" }[0]
    assert_not_nil kirito
    assert_not kirito[:description].empty?
    assert_equal "Kazuto Kirigaya", kirito[:name]
    assert_equal "Main", kirito[:role]
    assert_instance_of URI::HTTP, kirito[:image]
    assert_equal 36765, kirito[:external_id]
  end

  test "can get anime character's voice actors" do
    fake_anime_urls
    chars = MALImport.new(:anime, 11757).characters
    actors = chars.select { |c| c[:name] == "Kazuto Kirigaya" }[0][:voice_actors]
    assert_not_nil actors
    assert_not actors.empty?
    bryce = actors.select { |a| a[:name] == "Bryce Papenbrook" }[0]
    assert_equal "Bryce Papenbrook", bryce[:name]
    assert_equal "English", bryce[:lang]
    assert_instance_of URI::HTTP, bryce[:image]
    assert_equal 732, bryce[:external_id]
  end

  test "can get anime character's info with one-word name" do
    fake_anime_urls
    chars = MALImport.new(:anime, 11757).characters
    yui = chars.select { |c| c[:name] == "Yui" }[0]
    assert_not_nil yui
    assert_equal "Yui", yui[:name]
    assert_equal "Supporting", yui[:role]
    assert_instance_of URI::HTTP, yui[:image]
    assert_equal 43892, yui[:external_id]
  end

  test "can get anime staff" do
    fake_anime_urls
    staff = MALImport.new(:anime, 11757).staff
    assert_not_nil staff
    assert_not staff.empty?
    assert staff.select { |c| c[:name].include?(",") }.length == 0,
           "Found a name that wasn't flipped"
  end

  test "can get anime staff's info" do
    fake_anime_urls
    staff = MALImport.new(:anime, 11757).staff
    somedude = staff.select { |c| c[:name] == "Atsuhiro Iwakami" }[0]
    assert_equal "Atsuhiro Iwakami", somedude[:name]
    assert_equal "Producer", somedude[:role]
    assert_equal 14031, somedude[:external_id]
  end

  test "omits staff and characters in shallow mode" do
    fake_anime_urls
    malware = MALImport.new(:anime, 11757, :shallow).to_h
    assert_empty malware[:staff]
    assert_empty malware[:characters]
  end
end
