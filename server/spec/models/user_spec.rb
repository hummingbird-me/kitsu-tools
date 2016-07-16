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

RSpec.describe User, type: :model do
  subject { build(:user) }
  let(:persisted_user) { create(:user) }

  it { should define_enum_for(:rating_system) }
  it { should have_db_index(:facebook_id) }
  it { should belong_to(:pro_membership_plan) }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_uniqueness_of(:email).case_insensitive }

  describe 'by_name scope' do
    it 'should match case-insensitively' do
      u = User.by_name(persisted_user.name).first
      expect(u).to eq(persisted_user)
    end
  end

  describe 'find_for_auth' do
    it 'should be able to query by username' do
      u = User.find_for_auth(persisted_user.name)
      expect(u).to eq(persisted_user)
    end
    it 'should be able to query by email' do
      u = User.find_for_auth(persisted_user.email)
      expect(u).to eq(persisted_user)
    end
  end

  describe '#pro?' do
    it 'should return false if the user has no pro expiry' do
      user = build(:user, pro_expires_at: nil)
      expect(user).not_to be_pro
    end
    it 'should return false if the user has already run out of pro' do
      user = build(:user, pro_expires_at: 2.months.ago)
      expect(user).not_to be_pro
    end
    it 'should return true if the user still has pro left' do
      user = build(:user, pro_expires_at: 2.months.from_now)
      expect(user).to be_pro
    end
  end

  describe 'past_names' do
    subject { create(:user) }
    context 'when the user changes name for the first time' do
      it 'should include the old name' do
        old_name = subject.name
        subject.name = 'MisakaMikoto'
        subject.save!
        expect(subject.past_names).to include(old_name)
      end
    end
    it 'should push onto the front when user changes name multiple times' do
      expect {
        3.times do |i|
          subject.name = "Misaka100#{i}"
          subject.save!
        end
      }.to change { subject.past_names.length }.by(3)
    end
    it 'should limit to 10 in length' do
      expect {
        20.times do |i|
          subject.name = "Misaka100#{i}"
          subject.save!
        end
      }.to change { subject.past_names.length }.from(0).to(10)
    end
    it 'should remove duplicate names' do
      expect {
        10.times do
          subject.name = 'MisakaMikoto'
          subject.save!
        end
      }.to change { subject.past_names.length }.from(0).to(1)
    end
    it 'should return first in list when previous_name is called' do
      3.times do |i|
        subject.name = "Misaka100#{i}"
        subject.save
      end
      expect(subject.past_names[0]).to equal(subject.previous_name)
    end
  end
end
