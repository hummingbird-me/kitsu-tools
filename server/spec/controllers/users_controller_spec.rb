require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  USER ||= { name: String, pastNames: Array }
  CURRENT_USER ||= { email: String }.merge(USER)
  let(:user) { create(:user) }

  describe '#index' do
    describe 'with filter[self]' do
      it 'should respond with a user when authenticated' do
        sign_in user
        get :index, filter: { self: 'yes' }
        expect(response.body).to have_resources(CURRENT_USER, 'users')
        expect(response).to have_http_status(:ok)
      end
      it 'should respond with an empty list when unauthenticated' do
        get :index, filter: { self: 'yes' }
        expect(response.body).to have_empty_resource
      end
    end
    describe 'with filter[name]' do
      it 'should find by username' do
        get :index, filter: { name: user.name }
        expect(response.body).to have_resources(USER.merge(name: user.name), 'users')
      end
    end
  end

  describe '#show' do
    it 'should respond with a user' do
      get :show, id: user.id
      expect(response.body).to have_resource(USER, 'users')
    end
    it 'has status ok' do
      get :show, id: user.id
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
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
    it 'should respond with a user' do
      create_user
      expect(response.body).to have_resource(USER, 'users', singular: true)
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
    it 'should respond with a user' do
      update_user
      expect(response.body).to have_resource(USER, 'users', singular: true)
    end
  end
end
