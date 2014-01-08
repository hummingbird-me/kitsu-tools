namespace :compute do
  desc "Compute the Bayesian average rating for every show"
  task :bayesian_average => :environment do |t|
    #
    # Bayesian rating:
    #
    #     r * v / (v + m) + c * m / (v + m)
    #
    #   where:
    #     r: average for the show
    #     v: number of votes for the show
    #     m: minimum votes needed to display rating
    #     c: average across all shows
    #

    m = 50
    global_total_rating = 0
    global_total_votes  = 0
    anime_total_ratings = {}
    anime_total_votes   = {}

    Anime.find_each do |anime|
      anime_total_ratings[anime.id] ||= 0
      anime_total_votes[anime.id]   ||= 0

      anime.rating_frequencies.each do |rating_s, count_s|
        if rating_s != "nil"
          rating  = rating_s.to_f
          count   = count_s.to_f

          global_total_rating += rating * count
          global_total_votes  += count

          anime_total_ratings[anime.id] += rating * count
          anime_total_votes[anime.id]   += count
        end
      end

      STDERR.puts "Pass 1: #{anime.id}"
    end

    c = global_total_rating * 1.0 / global_total_votes

    Anime.find_each do |anime|
      v = anime_total_votes[anime.id]
      if v >= m
        r = anime_total_ratings[anime.id] * 1.0 / v
        anime.bayesian_average = (r * v + c * m) / (v + m)
      else
        anime.bayesian_average = nil
      end
      anime.save
      STDERR.puts "Pass 2: #{anime.id}"
    end
  end
end
