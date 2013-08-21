def ci_lower_bound(pos, n)
  return 0 if n == 0
  
  # z=1.96 corresponds to confidence=0.95
  # z=2.17 corresponds to confidence=0.97
  z = 2.17

  phat = 1.0*pos/n
  (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
end

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
        rating  = rating_s.to_f
        count   = count_s.to_f

        global_total_rating += rating * count
        global_total_votes  += count

        anime_total_ratings[anime.id] += rating * count
        anime_total_votes[anime.id]   += count
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
      anime.user_count = anime_total_ratings[anime.id]
      anime.save
      STDERR.puts "Pass 2: #{anime.id}"
    end
  end
end
