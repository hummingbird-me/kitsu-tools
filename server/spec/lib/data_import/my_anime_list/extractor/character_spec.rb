require 'rails_helper'

RSpec.describe DataImport::MyAnimeList::Extractor::Character do
  let(:character_html) { fixture('my_anime_list/guts-character.html') }

  subject { described_class.new(character_html, '422/Guts') }

  it 'should get character name' do
    expect(subject.name).to eq('Guts')
  end

  # it 'should get charater description' do
  #   expect(subject.description).to eq(1)
  # end

  it 'should get character image' do
    expect(subject.image_url).to eq({
      image: 'http://cdn.myanimelist.net/images/characters/13/284125.jpg'
    })
  end
end
