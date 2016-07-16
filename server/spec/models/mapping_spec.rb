# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null, indexed => [external_id, media_type, media_id]
#  media_type    :string           not null, indexed => [external_site, external_id, media_id]
#  external_id   :string           not null, indexed => [external_site, media_type, media_id]
#  media_id      :integer          not null, indexed => [external_site, external_id, media_type]
#
# Indexes
#
#  index_mappings_on_external_and_media  (external_site,external_id,media_type,media_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Mapping, type: :model do
  subject { build(:mapping) }
  it { should belong_to(:media) }
  it { should validate_presence_of(:media) }
  it { should validate_presence_of(:external_site) }
  it { should validate_presence_of(:external_id) }
  it do
    expect(subject).to validate_uniqueness_of(:media_id)
      .scoped_to(%i[media_type external_site])
  end

  describe '.lookup' do
    it 'should respond when it finds the correct media' do
      anime = create(:anime)
      create(:mapping, media: anime, external_site: 'myanimelist',
                       external_id: '17')
      expect(Mapping.lookup('myanimelist', '17')).to eq(anime)
    end
    it 'should return nil when it cannot find a matching media' do
      expect(Mapping.lookup('fakesite', '23')).to be_nil
    end
  end

  describe '.guess' do
    it 'should respond when it finds the correct media' do
      anime = create(:anime)
      expect(Mapping.guess('Anime', title: anime.canonical_title)).to eq(anime)
    end

    it 'should respond with nil when it cannot find a reasonable match' do
      expect(Mapping.guess('Anime', title: 'Such Ass Ohmy')).to be_nil
    end
  end
end
