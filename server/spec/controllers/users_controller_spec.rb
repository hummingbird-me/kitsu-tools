# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  about                       :string(500)      default(""), not null
#  about_formatted             :text
#  approved_edit_count         :integer          default(0)
#  avatar_content_type         :string(255)
#  avatar_file_name            :string(255)
#  avatar_file_size            :integer
#  avatar_processing           :boolean
#  avatar_updated_at           :datetime
#  bio                         :string(140)      default(""), not null
#  confirmation_sent_at        :datetime
#  confirmation_token          :string(255)      indexed
#  confirmed_at                :datetime
#  cover_image_content_type    :string(255)
#  cover_image_file_name       :string(255)
#  cover_image_file_size       :integer
#  cover_image_updated_at      :datetime
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string(255)
#  dropbox_secret              :string(255)
#  dropbox_token               :string(255)
#  email                       :string(255)      default(""), not null, indexed
#  encrypted_password          :string(255)      default(""), not null
#  followers_count             :integer          default(0)
#  following_count             :integer          default(0)
#  import_error                :string(255)
#  import_from                 :string(255)
#  import_status               :integer
#  last_backup                 :datetime
#  last_recommendations_update :datetime
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string(255)
#  life_spent_on_anime         :integer          default(0), not null
#  location                    :string(255)
#  mal_username                :string(255)
#  name                        :string(255)
#  ninja_banned                :boolean          default(FALSE)
#  onboarded                   :boolean          default(FALSE), not null
#  past_names                  :string           default([]), not null, is an Array
#  pro_expires_at              :datetime
#  rating_system               :integer          default(1)
#  recommendations_up_to_date  :boolean
#  rejected_edit_count         :integer          default(0)
#  remember_created_at         :datetime
#  reset_password_sent_at      :datetime
#  reset_password_token        :string(255)
#  sfw_filter                  :boolean          default(TRUE)
#  sign_in_count               :integer          default(0)
#  stripe_token                :string(255)
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  title_language_preference   :string(255)      default("canonical")
#  to_follow                   :boolean          default(FALSE), indexed
#  unconfirmed_email           :string(255)
#  waifu_or_husbando           :string(255)
#  website                     :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  facebook_id                 :string(255)      indexed
#  pro_membership_plan_id      :integer
#  stripe_customer_id          :string(255)
#  waifu_id                    :integer          indexed
#
# Indexes
#
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_email               (email) UNIQUE
#  index_users_on_facebook_id         (facebook_id) UNIQUE
#  index_users_on_to_follow           (to_follow)
#  index_users_on_waifu_id            (waifu_id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  USER ||= { name: String, pastNames: Array }.freeze
  CURRENT_USER ||= { email: String }.merge(USER).freeze
  let(:user) { create(:user) }

  describe '#index' do
    describe 'with filter[self]' do
      it 'should respond with a user when authenticated' do
        sign_in user
        get :index, filter: { self: 'yes' }
        expect(response.body).to have_resources(CURRENT_USER.dup, 'users')
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
        user_json = USER.merge(name: user.name)
        expect(response.body).to have_resources(user_json, 'users')
      end
    end
  end

  describe '#show' do
    it 'should respond with a user' do
      get :show, id: user.id
      expect(response.body).to have_resource(USER.dup, 'users')
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
      expect(response.body).to have_resource(USER.dup, 'users', singular: true)
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
      expect(response.body).to have_resource(USER.dup, 'users', singular: true)
    end
  end
end
