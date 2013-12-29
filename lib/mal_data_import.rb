class MALDataImport
  def self.manga_from_json(json, import_poster_image=false)
    raise ArgumentError, "JSON must contain MAL ID" if json["mal_id"].nil?

    manga = Manga.find_by_mal_id(json["mal_id"]) || Manga.new(mal_id: json["mal_id"])

    manga.romaji_title = json["romaji_title"] if json["romaji_title"]
    manga.english_title = json["english_title"] if json["english_title"]
    manga.synopsis = json["synopsis"] if json["synopsis"]
    manga.status = json["status"] if json["status"]
    manga.start_date = DateTime.parse(json["dates"]["from"]).to_date if json["dates"] and json["dates"]["from"]
    manga.end_date = DateTime.parse(json["dates"]["to"]).to_date if json["dates"] and json["dates"]["to"]
    manga.volume_count = json["volumes"]
    manga.chapter_count = json["chapters"]

    if import_poster_image
      manga.poster_image = URI(json["poster_image"]) if json["poster_image"]
    end

    manga.save
  end
end
