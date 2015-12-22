require 'rails_helper'

RSpec.shared_examples 'media' do
  include_examples 'titleable'

  # Columns which are mandatory for all media
  it { should have_db_column(:slug).of_type(:string) }
  it { should have_db_column(:abbreviated_titles).of_type(:string) }
  it { should have_db_column(:average_rating).of_type(:float) }
  it { should have_db_column(:rating_frequencies).of_type(:hstore) }
  it { should have_db_column(:start_date).of_type(:date) }
  it { should have_db_column(:end_date).of_type(:date) }
  it { should have_and_belong_to_many(:genres) }
  it { should have_many(:castings) }
  # Methods used for the magic
  it { should respond_to(:slug_candidates) }
  it { should delegate_method(:year).to(:start_date) }
  it {
    should validate_numericality_of(:average_rating)
      .is_less_than_or_equal_to(5)
      .is_greater_than(0)
  }
end
