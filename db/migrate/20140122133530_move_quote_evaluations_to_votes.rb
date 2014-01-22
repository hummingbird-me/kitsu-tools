class MoveQuoteEvaluationsToVotes < ActiveRecord::Migration
  def up
    Quote.find_each do |quote|
      quote.evaluations.each do |ev|
        if Vote.for(ev.source, quote).nil?
          Vote.create(user: ev.source, target: quote)
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
