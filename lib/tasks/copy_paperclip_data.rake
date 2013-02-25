desc "Copy paperclip data from the default URL scheme to a new scheme."
task :copy_paperclip_data => :environment do
  @anime = Anime.all
  puts "Found #{@anime.length} attachments"
  old_path = Rails.root.join("public", "system", ":class", ":attachment", ":id_partition", ":style", ":filename").to_s
  @anime.each do |anime|
    unless anime.cover_image_file_name.blank?
      old_file_path = Paperclip::Interpolations.interpolate(old_path, anime.cover_image, anime.cover_image.default_style)
      if File.exists? old_file_path
        image = File.new old_file_path
        anime.cover_image = image
        anime.save
        image.close
        puts "Copied cover image for #{anime.title}."
      end
    end
  end
end
