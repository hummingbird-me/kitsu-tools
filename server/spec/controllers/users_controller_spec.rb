require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'show user' do
    it 'assigns @user' do
      user = create(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
    it 'has status ok' do
      user = create(:user)
      get :show, id: user.id
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'create user' do
    def create_user
      post :create, user: {
        name: 'Senjougahara',
        bio: 'hitagi crab',
        email: 'senjougahara@hita.gi',
        password: 'headtilt'
      }
    end

    it 'assigns a persisted @user' do
      create_user
      expect(assigns(:user).persisted?).to be true
    end
    it 'has status ok' do
      create_user
      expect(response).to have_http_status(:ok)
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
      post :update, id: user.id, user: {
        id: user.id,
        name: 'crab'
      }
    end

    it 'assigns @user' do
      update_user
      expect(assigns(:user)).to be_a User
    end
    it 'has status ok' do
      update_user
      p response.body
      expect(response).to have_http_status(:ok)
    end
    it 'should update the user' do
      update_user
      user.reload
      expect(user.name).to eq 'crab'
    end
  end
end
