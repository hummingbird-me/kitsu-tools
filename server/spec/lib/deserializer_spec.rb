require 'deserializer'

RSpec.describe 'Deserializer' do
  let(:deserializer) do
    deserializer = Class.new(::Deserializer)
    allow(deserializer).to receive(:fields) { %i[foo bar] }
    allow(deserializer).to receive(:key) { :id }
    deserializer
  end
  let(:instance) { double('instance') }
  let(:model) { double('model') }

  def params(h = {})
    ActionController::Parameters.new(h)
  end

  it 'should always remove fields which are not allowed' do
    p = params(foo: 'bar', boom: 'bah')
    f = deserializer.new(p).filter
    expect(f).to eq(foo: 'bar')
  end

  it 'should find and assign if existing model' do
    expect(model).to receive(:find) { instance }
    expect(instance).to receive(:assign_attributes)
    deserializer.model(model)
    deserializer.new(params(id: 2)).deserialize
  end

  it 'should instantiate and assign if new model' do
    expect(model).to receive(:new) { instance }
    expect(instance).to receive(:assign_attributes)
    deserializer.model(model)
    deserializer.new(params, create: true).deserialize
  end

  # Using symbol and class method for a condition
  context 'with symbol conditions' do
    before do
      allow(deserializer).to receive(:conditions) do
        { foo: :hello? }
      end
      deserializer.class_eval do
        def self.hello?
          false
        end
      end
    end

    it 'should remove fields which do not pass' do
      p = params(foo: 'a', bar: 'b')
      f = deserializer.new(p).filter
      expect(f).to eq(bar: 'b')
    end
  end

  # Using a lambda for a condition
  context 'with lambda conditions' do
    before do
      allow(deserializer).to receive(:conditions) do
        { foo: ->{ false } }
      end
    end

    it 'should remove fields which do not pass' do
      p = params(foo: 'a', bar: 'b')
      f = deserializer.new(p).filter
      expect(f).to eq(bar: 'b')
    end
  end
end
