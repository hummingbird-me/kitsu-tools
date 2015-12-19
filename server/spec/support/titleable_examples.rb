require 'rails_helper'

RSpec.shared_examples 'titleable' do
  # Columns which are mandatory for all titleables
  it { should have_db_column(:titles).of_type(:hstore) }
  it { should have_db_column(:canonical_title).of_type(:string) }
  # Methods used for the magic
  it { should respond_to(:canonical_title) }
end
