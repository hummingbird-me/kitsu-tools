require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'show user' do
    describe 'with id=me' do
      it 'shows when authenticated' do
        user = create(:user)
        sign_in user
        get :show, id: 'me'
        expect(response).to redirect_to(user)
      end
      it 'errors when unauthenticated' do
        get :show, id: 'me'
        expect(response).to have_http_status(:not_found)
      end
    end
    it 'has status ok' do
      user = create(:user)
      get :show, id: user.id
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'create user' do
    def create_user
      post :create, data: {
        type: 'users',
        attributes: {
          name: 'Senjougahara',
          bio: 'hitagi crab',
          email: 'senjougahara@hita.gi',
          password: 'headtilt'
        }
      }
    end

    it 'has status created' do
      create_user
      expect(response).to have_http_status(:created)
    end
    it 'should have one more user than before' do
      expect {
        create_user
      }.to change { User.count }.by(1)
    end
  end

  describe 'update user' do
    let(:user) { create(:user) }
    def update_user
      sign_in user
      post :update, id: user.id, data: {
        type: 'users',
        id: user.id,
        attributes: {
          name: 'crab'
        }
      }
    end

    it 'has status ok' do
      update_user
      expect(response).to have_http_status(:ok)
    end
    it 'should update the user' do
      update_user
      user.reload
      expect(user.name).to eq 'crab'
    end
  end
end
