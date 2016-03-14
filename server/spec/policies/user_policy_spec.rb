require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { build(:user) }
  let(:admin) { create(:user, :admin) }
  let(:other) { build(:user) }
  subject { described_class }

  permissions :show? do
    it ('should allow anons') { should permit(nil, other) }
    it ('should allow users') { should permit(user, other) }
  end

  permissions :create? do
    it ('should allow admins') { should permit(admin, other) }
    it ('should allow normal users') { should permit(user, other) }
    it ('should allow anon') { should permit(nil, other) }
  end

  permissions :update? do
    context 'for self' do
      it ('should allow normal users') { should permit(user, user) }
      it ('should allow admins') { should permit(admin, admin) }
    end
    context 'for other' do
      it ('should not allow normal users') { should_not permit(user, other) }
      it ('should not allow anons') { should_not permit(nil, other) }
      it ('should allow admins') { should permit(admin, other) }
    end
  end

  permissions :destroy? do
    it ('should allow admins') { should permit(admin, other) }
    it ('should not allow normal users') { should_not permit(user, other) }
    it ('should not allow anon') { should_not permit(nil, other) }
  end
end
