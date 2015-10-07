require 'rails_helper'

RSpec.describe AnimePolicy do
  let(:user) { build(:user) }
  let(:admin) { create(:administrator) }
  let(:anime) { build(:anime) }
  subject { described_class }

  permissions :show? do
    it ('should allow users') { should permit(user, anime) }
    it ('should allow anons') { should permit(nil, anime) }
  end

  permissions :create?, :update?, :destroy? do
    it ('should allow admins') { should permit(admin, anime) }
    it ('should not allow normal users') { should_not permit(user, anime) }
    it ('should not allow anon') { should_not permit(nil, anime) }
  end
end
