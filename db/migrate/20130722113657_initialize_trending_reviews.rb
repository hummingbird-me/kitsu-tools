class InitializeTrendingReviews < ActiveRecord::Migration
  def up
    ReputationSystem::Evaluation.where(target_type: "Review").find_each do |x| 
      if x.value == 1; 
        $redis.zincrby "trending_reviews", 2.0**((x.created_at.to_i - Date.new(2020, 1, 1).to_time.to_i) / 7.days.to_i), x.target_id
      end
    end
  end

  def down
  end
end
