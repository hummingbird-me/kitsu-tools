require 'rails_helper'

RSpec.describe DataImport::MyAnimeList::Extractor::Character do
  let(:character_html) { fixture('my_anime_list/guts-character.html') }
  # don't need to pass in 422/Guts
  subject { described_class.new(character_html, '422') }

  describe '#name' do
    it 'should get english character name' do
      expect(subject.name).to eq('Guts')
    end

    it 'should get japanese character name' do
      # 'Nuck needs to change character name from string to hstore'
      # expect(subject.name).to eq('ガッツ')
    end
  end

  describe '#description' do
    # it 'should get charater description' do
    #   expect(subject.description).to eq(1)
    # end
  end

  describe '#image_url' do
    it 'should get character image' do
      expect(subject.image_url).to eq(
        image: 'http://cdn.myanimelist.net/images/characters/13/284125.jpg'
      )
    end
  end
end
