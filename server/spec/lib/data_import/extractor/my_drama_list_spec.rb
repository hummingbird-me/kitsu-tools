require 'rails_helper'
require 'data_import/extractor/my_drama_list'

RSpec.describe DataImport::Extractor::MyDramaList, :focus do
  let(:details) { fixture('my_drama_list/karate-robo-zaborgar.html') }
  let(:cast) { fixture('my_drama_list/karate-robo-zaborgar-cast.html') }
  subject { DataImport::Extractor::MyDramaList.new(details, cast) }

  it 'should extract title from the page' do
    expect(subject.title).to eq('Karate-Robo Zaborgar (2011)')
  end

  it 'should extract details from righthand sidebar' do
    expect(subject.details['Country']).to eq('Japan')
    expect(subject.details['Type']).to eq('Movie')
    expect(subject.details['Release Date']).to eq('Oct 15, 2011')
    expect(subject.details['Duration']).to eq('1 hr. 54 min.')
    expect(subject.details['Native title']).to eq('電人ザボーガー')
  end

  it 'should extract synopsis from the page' do
    expect(subject.synopsis).to eq(<<-EOF.strip_heredoc.gsub(/\s+/, ' ').strip)
      An evil criminal organisation called Sigma kidnap prominment business
      leaders to harvest their DNA and only Karate-Robo Zaborgar can save them
    EOF
  end

  it 'should extract genres from the page' do
    expect(subject.genres).to eq(%w[Action Sci-Fi Tokusatsu])
  end

  it 'should extract poster image from the page' do
    expect(subject.poster_image).to include('158866959117997028_2835ca55_f.jpg')
  end

  it 'should extract cast members from the cast page' do
    expect(subject.cast.count).to eq(6)
    expect(subject.cast).to include({
      actor: {
        id: '2062',
        image: 'http://i.mdldb.net/cache/QeQ/z/VLQJ7wz3_7d9ffc_f.jpg',
        name: 'Itao Itsuji'
      },
      character: {
        name: 'Yutaka Daimon',
        role: 'Main Role'
      }
    })
  end
end
