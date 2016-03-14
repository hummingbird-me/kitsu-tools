require 'rails_helper'

RSpec.describe CastingPolicy do
  let(:user) { build(:user) }
  let(:admin) { create(:user, :admin) }
  let(:casting) { build(:casting) }

  subject { described_class }

  permissions :show? do
    it ('should allow anons') { should permit(nil, casting) }
    it ('should allow users') { should permit(user, casting) }
    it ('should allow admins') { should permit(admin, casting) }
  end
end
