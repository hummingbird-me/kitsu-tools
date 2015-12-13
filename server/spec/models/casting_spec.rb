require 'rails_helper'

RSpec.describe Casting, type: :model do
  it { should belong_to(:media) }
  it { should validate_presence_of(:media) }
  it { should belong_to(:character) }
  it { should validate_presence_of(:character) }
end
