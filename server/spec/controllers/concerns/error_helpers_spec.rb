require 'rails_helper'

RSpec.describe ErrorHelpers do
  let(:controller) do
    Class.new do
      include ErrorHelpers

      def render(*); end

      def params; end
    end
  end
  let(:instance) { controller.new }

  context 'error! method' do
    it 'should render a 400 with an errors key in json for a model' do
      expect(instance).to receive(:render).with(
        json: { errors: [{ title: 'bar', source: { parameter: :foo } }] },
        status: 400
      )
      fake_model = double('fake model')
      allow(fake_model).to receive(:errors) { { foo: ['bar'] } }
      instance.error! fake_model
    end
    it 'should render a simple error message' do
      expect(instance).to receive(:render).with(
        json: { errors: [{ title: 'foo' }] },
        status: 403
      )
      instance.error! 403, 'foo'
    end
  end

  context 'save_or_error! method' do
    let(:fake_model) { double('model') }
    it 'should render the json of the model if it succeeds' do
      allow(fake_model).to receive(:save) { true }
      expect(instance).to receive(:render).with(json: fake_model)
      instance.save_or_error! fake_model
    end
    it 'should send the model to #error! if it fails' do
      allow(fake_model).to receive(:save) { false }
      expect(instance).to receive(:error!).with(fake_model)
      instance.save_or_error! fake_model
    end
  end

  context 'validate_id method' do
    let(:fake_model) { double('model') }
    it 'should return true if the model and params ids match' do
      allow(instance).to receive(:params) { { id: 5 } }
      allow(fake_model).to receive(:id) { 5 }
      expect(instance.validate_id(fake_model)).to eq(true)
    end
    it 'should call the #error! method if the ids do not match' do
      allow(instance).to receive(:params) { { id: 5 } }
      allow(fake_model).to receive(:id) { 2 }
      expect(instance).to receive(:error!).with(400, 'ID mismatch')
      instance.validate_id(fake_model)
    end
  end
end
