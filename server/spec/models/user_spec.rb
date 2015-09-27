require 'rails_helper'

RSpec.describe User, type: :model do
  let(:persisted_user) { create(:user) }

  it 'should be able to query for authentication by username' do
    u = User.find_for_auth(persisted_user.name)
    expect(u).to eq(persisted_user)
  end

  it 'should be able to query for authentication by email' do
    u = User.find_for_auth(persisted_user.email)
    expect(u).to eq(persisted_user)
  end
end
