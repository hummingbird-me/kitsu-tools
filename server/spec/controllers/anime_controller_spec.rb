require 'rails_helper'

RSpec.describe AnimeController, type: :controller do
  ANIME ||= {
    titles: { ja_en: String },
    canonicalTitle: String
  }
  let(:anime) { create(:anime) }

  describe '#index' do
    describe 'with filter[slug]' do
      it 'should respond with an anime' do
        get :index, filter: { slug: anime.slug }
        expect(response.body).to have_resources(ANIME, 'anime')
      end
    end
  end

  describe '#show' do
    it 'should respond with an anime' do
      get :show, id: anime.id
      expect(response.body).to have_resource(ANIME, 'anime')
    end
    it 'has status ok' do
      get :show, id: anime.id
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    def create_anime
      post :create, data: {
        type: 'anime',
        attributes: {
          titles: {
            ja_en: 'Boku no Pico'
          },
          canonicalTitle: 'ja_en',
          abbreviatedTitles: ['BnP'],
          startDate: '2006-09-07',
          endDate: '2006-09-07'
        }
      }
    end

    let(:admin) { create(:user, :admin) }

    before do
      sign_in admin
    end

    it 'has status created' do
      create_anime
      expect(response).to have_http_status(:created)
    end
    it 'should have one more anime than before' do
      expect {
        create_anime
      }.to change { Anime.count }.by(1)
    end
    it 'should respond with an anime' do
      create_anime
      expect(response.body).to have_resource(ANIME, 'anime')
    end
  end
end
