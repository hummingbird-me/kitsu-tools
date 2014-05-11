namespace :fixes do

  #desc 'Generate formatted comment for substories'
  task substory_comment_formatting: :environment do
    Substory.where("data::hstore? 'comment'").find_in_batches do |group|
      group.each(&:save)
    end
  end

end
