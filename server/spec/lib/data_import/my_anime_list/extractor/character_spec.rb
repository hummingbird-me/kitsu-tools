require 'rails_helper'

RSpec.describe DataImport::MyAnimeList::Extractor::Character do
  let(:guts_character) { fixture('my_anime_list/characters/guts-character.html') }
  let(:faye_valentine_character) { fixture('my_anime_list/characters/faye-valentine-character.html') }
  let(:kyou_aguri_character) { fixture('my_anime_list/characters/kyou-aguri-character.html') }
  let(:sachi_nanjou_character) { fixture('my_anime_list/characters/sachi-nanjou-character.html') }
  let(:shichiroji_character) { fixture('my_anime_list/characters/shichiroji-character.html') }
  # don't need to pass in 422/Guts
  subject { described_class.new(guts_character, '422') }

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
    it 'should get Guts charater description' do
      amount = subject.description.join.scan(/<\/p>/).length

      expect(amount).to eq(2)
    end
    it 'should get Faye Valentine charater description' do
      subject = described_class.new(faye_valentine_character, '2')
      amount = subject.description.join.scan(/<\/p>/).length

      expect(amount).to eq(4)
    end
    it 'should get Kyou Aguri charater description' do
      subject = described_class.new(kyou_aguri_character, '216')
      amount = subject.description.join.scan(/<\/p>/).length

      expect(amount).to eq(0)
    end
    it 'should get Sachi Nanjou charater description' do
      subject = described_class.new(sachi_nanjou_character, '58443')
      amount = subject.description.join.scan(/<\/p>/).length

      expect(amount).to eq(1)
    end
    it 'should get Shichiroji charater description' do
      subject = described_class.new(shichiroji_character, '156')
      amount = subject.description.join.scan(/<\/p>/).length

      expect(amount).to eq(4)
    end
  end

  describe '#image_url' do
    it 'should get character image' do
      expect(subject.image_url).to eq(
        image: 'http://cdn.myanimelist.net/images/characters/13/284125.jpg'
      )
    end
  end
end
