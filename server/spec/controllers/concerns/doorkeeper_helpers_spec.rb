require 'rails_helper'

RSpec.describe DoorkeeperHelpers do
  let(:token) { double('token') }
  let(:controller) do
    Class.new do
      include DoorkeeperHelpers

      def render(*); end

      def doorkeeper_token; end
    end
  end
  let(:instance) { controller.new }

  context 'current_user method' do
    it 'should return a User instance when there is one logged in' do
      user = create(:user)
      allow(instance).to receive(:doorkeeper_token) { token }
      allow(token).to receive(:resource_owner_id) { user.id }
      expect(instance.current_user).to eq(user)
    end
    it 'should return nil when there is nobody logged in' do
      allow(instance).to receive(:doorkeeper_token) { nil }
      expect(instance.current_user).to be_nil
    end
  end

  context 'signed_in? method' do
    it 'should return true if logged in' do
      allow(instance).to receive(:current_user) { build(:user) }
      expect(instance.signed_in?).to be true
    end
    it 'should return false if not logged in' do
      allow(instance).to receive(:current_user) { nil }
      expect(instance.signed_in?).to be false
    end
  end
end
