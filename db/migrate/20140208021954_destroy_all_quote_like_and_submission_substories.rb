class DestroyAllQuoteLikeAndSubmissionSubstories < ActiveRecord::Migration
  def up
    Substory.where(substory_type: ["liked_quote", "submitted_quote"]).find_each {|x| x.destroy }
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
