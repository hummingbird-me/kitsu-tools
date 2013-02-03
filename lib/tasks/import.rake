namespace :import do
  desc "Import pseudo-JSON formatted anime metadata from MAL"
  task :anime_metadata, [:filename] => :environment do |t, args|
    File.open(args[:filename]).readlines.map {|x| JSON.load x }.each do |meta|
      a = Anime.find_or_create_by_title(meta["title"])
      a.title = meta["title"]
      a.alt_title = meta["aka"]
      a.mal_id = meta["mal_id"]
      a.status = meta["status"]
      a.synopsis = meta["synopsis"]
      a.age_rating = meta["rating"]
      a.cover_image_url = meta["cover_image_url"]
      a.save
    end
  end
end
