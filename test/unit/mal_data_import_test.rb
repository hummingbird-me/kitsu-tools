require 'test_helper'
require 'mal_data_import'

class MALDataImportTest < ActiveSupport::TestCase
  def test_manga_from_json_requires_mal_id
    assert_raise(ArgumentError) { MALDataImport.manga_from_json({}) }
    assert_nothing_raised { MALDataImport.manga_from_json({"mal_id" => 1}) }
  end

  def test_manga_from_json_sets_properties
    json = JSON.parse '{"mal_id":1,"romaji_title":"Monster","english_title":null,"synopsis":"Dr. Kenzo Tenma is a renowned young brain surgeon of Japanese descent working in Europe. Highly lauded by his peers as one of the great young minds that will revolutionize the field, he is blessed with a beautiful fiancé and is on the cusp of a high promotion in the hospital he works at. However, all of that is about to change with one critical decision that Dr. Tenma faces one night – whether to save the life of a young child or that of the town\'s mayor. Despite being pressured by his superiors to perform surgery on the mayor, his morals force him to perform the surgery on the young child, saving his life and forfeiting the mayor’s. All of a sudden, Dr. Tenma’s world is turned upside down by his decision leading to the loss of everything he previously had. A doctor is taught to believe that all life is equal; however, when a series of murders occur in the vicinity of Dr. Tenma, all of the evidence pointing to the young child who he saved, Tenma’s beliefs are shaken.\nNaoki Urasawa’s Monster is a tale full of mystery, suspense and intrigue as Dr. Tenma journeys to find out the true identity of the young child. In turn, the fate of the world may depend on it.\n[Written by MAL Rewrite]","characters":[["Eva Heinemann",6123],["Johan Liebert",719],["Anna Liebert",720],["Heinrich Lunge",721],["Kenzo Tenma",718],["Blue Sophie",36224],["Dieter",6329]],"poster_image":"http://cdn.myanimelist.net/images/manga/3/54525.jpg","genres":["Mystery","Drama","Psychological","Seinen"],"volumes":18,"chapters":162,"status":"Finished","authors":[["Naoki Urasawa",1867]],"dates":{"from":"1994-12-05","to":"2001-12-20"},"serialization":["Big Comic Original"]}'
    MALDataImport.manga_from_json json
    manga = Manga.find_by_mal_id json["mal_id"]

    assert_equal json["romaji_title"], manga.romaji_title
    assert_equal json["english_title"], manga.english_title
    assert_equal json["synopsis"], manga.synopsis
    assert_equal json["status"], manga.status
    assert_equal DateTime.parse(json["dates"]["from"]).to_date, manga.start_date
    assert_equal DateTime.parse(json["dates"]["to"]).to_date, manga.end_date
    assert_equal json["volumes"], manga.volume_count
    assert_equal json["chapters"], manga.chapter_count
    assert_equal json["genres"], manga.genres.map {|x| x.name }
  end
end
