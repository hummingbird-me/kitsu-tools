require 'rails_helper'

RSpec.describe Drama, type: :model do
  include_examples 'media'
  include_examples 'episodic'
  include_examples 'age_ratings'
end
