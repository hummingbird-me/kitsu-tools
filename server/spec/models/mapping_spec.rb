require 'rails_helper'

RSpec.describe Mapping, type: :model do
  subject { build(:mapping) }
  it { should belong_to(:media) }
  it { should validate_presence_of(:media) }
  it { should validate_presence_of(:external_site) }
  it { should validate_presence_of(:external_id) }
  it { should validate_uniqueness_of(:media_id)
        .scoped_to([:media_type, :external_site]) }
  describe '.lookup' do
    it 'should respond when it finds the correct media' do
      anime = create(:anime)
      mapping = create(:mapping, media: anime, external_site: 'myanimelist',
                                 external_id: '17')
      expect(Mapping.lookup('myanimelist', '17')).to eq(anime)
    end
    it 'should return nil when it cannot find a matching media' do
      expect(Mapping.lookup('fakesite', '23')).to be_nil
    end
  end
end
