require 'rails_helper'

RSpec.describe LibraryEntryPolicy do
  let(:owner) { build(:user) }
  let(:user) { build(:user) }
  let(:admin) { create(:user, :admin) }
  let(:entry) { build(:library_entry, user: owner) }
  subject { described_class }

  permissions :show? do
    let(:pervert) { build(:user, sfw_filter: false) }
    let(:hentai_entry) { build(:library_entry, :nsfw, user: owner) }
    let(:private_entry) { build(:library_entry, user: owner, private: true) }
    context 'for owner' do
      it ('should allow normal entries') { should permit(owner, entry) }
      it ('should allow lewd entries') { should permit(owner, hentai_entry) }
      it ('should allow private entries') { should permit(owner, private_entry) }
    end
    context 'for other, non-perverted user' do
      it ('should allow normal entries') { should permit(user, entry) }
      it ('should not allow lewd entries') { should_not permit(user, hentai_entry) }
      it ('should not allow private entries') { should_not permit(user, private_entry) }
    end
    context 'for anon' do
      it ('should allow normal entries') { should permit(user, entry) }
      it ('should not allow lewd entries') { should_not permit(user, hentai_entry) }
      it ('should not allow private entries') { should_not permit(user, private_entry) }
    end
    context 'for other, perverted user' do
      it ('should allow normal entries') { should permit(pervert, entry) }
      it ('should allow lewd entries') { should permit(pervert, hentai_entry) }
      it ('should not allow private entries') { should_not permit(pervert, private_entry) }
    end
    context 'for admin' do
      it ('should allow normal entries') { should permit(admin, entry) }
      it ('should allow lewd entries') { should permit(admin, hentai_entry) }
      it ('should allow private entries') { should permit(admin, private_entry) }
    end
  end

  permissions :create?, :update?, :destroy? do
    it ('should allow owner') { should permit(owner, entry) }
    it ('should allow admin') { should permit(admin, entry) }
    it ('should not allow random dude') { should_not permit(user, entry) }
    it ('should not allow anon') { should_not permit(nil, entry) }
  end
end
