require 'rails_helper'

RSpec.describe DataImport::MyAnimeList::Extractor::Character do
  let(:guts_character) { fixture('my_anime_list/characters/guts-character.html') }
  let(:faye_character) { fixture('my_anime_list/characters/faye-character.html') }
  let(:kyou_character) { fixture('my_anime_list/characters/kyou-character.html') }
  let(:sachi_character) { fixture('my_anime_list/characters/sachi-character.html') }
  let(:shichi_character) { fixture('my_anime_list/characters/shichi-character.html') }
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
      amount = subject.description.scan(%r{</p>}).length

      expect(amount).to eq(3)
    end
    it 'should get Faye Valentine charater description' do
      subject = described_class.new(faye_character, '2')
      amount = subject.description.scan(%r{</p>}).length
      expect(amount).to eq(5)
    end
    it 'should get Kyou Aguri charater description' do
      subject = described_class.new(kyou_character, '216')
      amount = subject.description.scan(%r{</p>}).length

      expect(amount).to eq(1)
    end
    it 'should get Sachi Nanjou charater description' do
      subject = described_class.new(sachi_character, '58443')
      amount = subject.description.scan(%r{</p>}).length

      expect(amount).to eq(1)
    end
    it 'should get Shichiroji charater description' do
      subject = described_class.new(shichi_character, '156')
      amount = subject.description.scan(%r{</p>}).length

      expect(amount).to eq(4)
    end
  end

  describe '#image' do
    it 'should get guts character image' do
      expect(subject.image).to eq(
        'http://cdn.myanimelist.net/images/characters/13/284125.jpg'
      )
    end
    it 'should get faye character image' do
      subject = described_class.new(faye_character, '2')

      expect(subject.image).to eq(
        'https://myanimelist.cdn-dena.com/images/characters/13/30532.jpg'
      )
    end
  end
end
