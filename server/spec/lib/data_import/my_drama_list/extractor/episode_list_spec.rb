require 'rails_helper'

RSpec.describe DataImport::MyDramaList::Extractor::EpisodeList do
  let(:html) { fixture('my_drama_list/signal-episodes.html') }
  subject { described_class.new(html) }

  it 'should allow iteration over episodes' do
    expect(subject.count).to eq(16)
    expect(subject).to include(
      image: 'http://i.mdldb.net/cache/mWb/w/z1dVbjn3_f80ad7_f.jpg',
      title: 'Signal Episode 1',
      air_date: 'Jan 22, 2016',
      number: '1',
      summary: <<-EOF.strip_heredoc.gsub(/\s+/, ' ').strip,
        By a rainy afternoon, the young Park Hae Yeong see a woman pick up a
        girl from school. But soon, he finds out that the girl is missing and
        the suspect is a man! Years later, the case…
      EOF
    )
  end
end
