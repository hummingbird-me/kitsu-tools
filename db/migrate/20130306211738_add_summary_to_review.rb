class AddSummaryToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :summary, :string
  end
end
