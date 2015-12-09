require 'rails_helper'

RSpec.describe AnimePolicy do
  let(:user) { build(:user) }
  let(:pervert) { build(:user, sfw_filter: false) }
  let(:admin) { create(:user, :admin) }
  let(:mod) { create(:user, :anime_admin) }
  let(:anime) { build(:anime) }
  let(:hentai) { build(:anime, :nsfw) }
  subject { described_class }

  permissions :show? do
    context 'for sfw' do
      it ('should allow users') { should permit(user, anime) }
      it ('should allow anons') { should permit(nil, anime) }
    end
    context 'for nsfw' do
      it ('should not allow anons') { should_not permit(nil, hentai) }
      it ('should not allow kids') { should_not permit(user, hentai) }
      it ('should allow perverts') { should permit(pervert, hentai) }
    end
  end

  permissions :create?, :update?, :destroy? do
    it ('should allow admins') { should permit(admin, anime) }
    it ('should not allow normal users') { should_not permit(user, anime) }
    it ('should not allow anon') { should_not permit(nil, anime) }
  end
end
