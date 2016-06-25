require 'rails_helper'

RSpec.describe DataImport::MyDramaList::Extractor::Details do
  let(:html) { fixture('my_drama_list/karate-robo-zaborgar.html') }
  subject { described_class.new(html) }

  it 'should extract title from the page' do
    expect(subject.title).to eq('Karate-Robo Zaborgar (2011)')
  end

  it 'should extract details from righthand sidebar' do
    expect(subject['Country']).to eq('Japan')
    expect(subject['Type']).to eq('Movie')
    expect(subject['Release Date']).to eq('Oct 15, 2011')
    expect(subject['Duration']).to eq('1 hr. 54 min.')
    expect(subject['Native title']).to eq('電人ザボーガー')
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
end
