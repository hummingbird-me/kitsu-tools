require 'rails_helper'

RSpec.describe AnimeController, type: :controller do
  let(:anime) { create(:anime) }

  describe 'show anime' do
    it 'assigns @anime' do
      get :show, id: anime.id
      expect(assigns(:anime)).to eq(anime)
    end
    it 'has status ok' do
      get :show, id: anime.id
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'create anime' do
    def create_anime
      post :create, data: {
        type: 'anime',
        attributes: {
          titles: {
            ja_en: 'Boku no Pico'
          },
          canonical_title: 'ja_en',
          abbreviated_titles: ['BnP'],
          start_date: '2006-09-07',
          end_date: '2006-09-07'
        }
      }
    end

    before do
      self.current_user = create(:user, :admin)
    end

    it 'assigns a persisted @anime with the right attributes' do
      create_anime
      expect(assigns(:anime)).to be_persisted
      expect(assigns(:anime).canonical_title).to eq('Boku no Pico')
    end
    it 'has status ok' do
      create_anime
      expect(response).to have_http_status(:ok)
    end
    it 'should have one more anime than before' do
      expect {
        create_anime
      }.to change { Anime.count }.by(1)
    end
  end
end
