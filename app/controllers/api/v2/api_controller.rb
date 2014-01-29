module Api::V2
  class ApiController < ActionController::Base

    # If x is blank return nil, otherwise x.
    def nfb(x)
      x.blank? ? nil : x
    end

    # Presenters.
    def present_anime(anime)
      {
        id: anime.slug,
        canonical_title: anime.canonical_title,
        english_title: nfb(anime.alt_title),
        romaji_title: nfb(anime.title),
        synopsis: anime.synopsis,
        poster_image: anime.poster_image_thumb,
        genres: anime.genres.map {|x| x.name },
        type: anime.show_type,
        started_airing: anime.started_airing_date,
        finished_airing: anime.finished_airing_date,
        screencaps: anime.gallery_images.map {|x| x.image.url(:thumb) },
        youtube_trailer_id: anime.youtube_video_id,
        community_rating: anime.bayesian_average
      }
    end
  end
end
