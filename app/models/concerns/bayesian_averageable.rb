# Requires a column named "rating_frequencies" of type "hstore" and default {}
module BayesianAverageable
  extend ActiveSupport::Concern

  module ClassMethods
    def recompute_bayesian_averages!
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
      media_total_ratings = {}
      media_total_votes   = {}

      self.find_each do |media|
        media_total_ratings[media.id] ||= 0
        media_total_votes[media.id]   ||= 0

        media.rating_frequencies.each do |rating_s, count_s|
          if rating_s != "nil"
            rating  = rating_s.to_f
            count   = count_s.to_f

            global_total_rating += rating * count
            global_total_votes  += count

            media_total_ratings[media.id] += rating * count
            media_total_votes[media.id]   += count
          end
        end

        STDERR.puts "Pass 1: #{media.id}"
      end

      c = global_total_rating * 1.0 / global_total_votes

      self.find_each do |media|
        v = media_total_votes[media.id]
        if v >= m
          r = media_total_ratings[media.id] * 1.0 / v
          media.bayesian_average = (r * v + c * m) / (v + m)
        else
          media.bayesian_average = 0
        end
        media.save
        STDERR.puts "Pass 2: #{media.id}"
      end
    end
  end
end
