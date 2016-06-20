require 'rails_helper'
require 'data_import/extractor/my_drama_list'

RSpec.describe DataImport::Extractor::MyDramaList, :focus do
  let(:html) { fixture('my_drama_list/karate-robo-zaborgar.html') }
  subject { DataImport::Extractor::MyDramaList.new(html) }

  it 'should extract details from righthand sidebar' do
    expect(subject.details['Country']).to eq('Japan')
    expect(subject.details['Type']).to eq('Movie')
    expect(subject.details['Release Date']).to eq('Oct 15, 2011')
    expect(subject.details['Duration']).to eq('1 hr. 54 min.')
  end

  it 'should extract synopsis from page' do
    expect(subject.synopsis).to eq(<<-EOF.strip_heredoc.gsub(/\s+/, ' ').strip)
      An evil criminal organisation called Sigma kidnap prominment business
      leaders to harvest their DNA and only Karate-Robo Zaborgar can save them
    EOF
  end

  it 'should extract genres from the page' do
    expect(subject.genres).to eq(%w[Action Sci-Fi Tokusatsu])
  end
end
