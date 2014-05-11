namespace :fixes do

  #desc 'Generate formatted comment for substories'
  task substory_comment_formatting: :environment do
    Substory.where("data::hstore? 'comment'").find_in_batches do |group|
      group.each(&:save)
    end
  end

  #desc 'Replace nulls with zeors for some numeric attributes on reviews'
  task replace_review_nulls: :environment do
    attributes = [:rating, :rating_animation, :rating_sound, :rating_character, :rating_enjoyment, :rating_story]
    attributes.each do |attr|
      puts Review.where(attr => nil).update_all(attr => 0)
    end
  end

end
