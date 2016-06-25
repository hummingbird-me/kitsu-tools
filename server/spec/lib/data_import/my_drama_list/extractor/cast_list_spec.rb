require 'rails_helper'

RSpec.describe DataImport::MyDramaList::Extractor::CastList do
  let(:html) { fixture('my_drama_list/karate-robo-zaborgar-cast.html') }
  subject { described_class.new(html) }

  it 'should allow iteration over cast members' do
    expect(subject.count).to eq(6)
    expect(subject).to include({
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
