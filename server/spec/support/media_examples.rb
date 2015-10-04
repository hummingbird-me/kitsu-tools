require 'rails_helper'

RSpec.shared_examples 'media' do
  # Columns which are mandatory for all media
  it { should have_db_column(:slug).of_type(:string) }
  it { should have_db_column(:titles).of_type(:hstore) }
  it { should have_db_column(:canonical_title).of_type(:string) }
  it { should have_db_column(:abbreviated_titles).of_type(:string) }
  it { should have_db_column(:average_rating).of_type(:float) }
  it { should have_db_column(:rating_frequencies).of_type(:hstore) }
  it { should have_db_column(:start_date).of_type(:date) }
  it { should have_db_column(:end_date).of_type(:date) }
  # Methods used for the magic
  it { should respond_to(:slug_candidates) }
  it { should respond_to(:canonical_title) }
  it { should delegate(:year).to(:start_date) }
  it {
    should validate_numericality_of(:average_rating)
      .is_less_than_or_equal_to(5)
      .is_greater_than(0)
  }
end
