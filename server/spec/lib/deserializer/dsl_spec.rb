require 'deserializer/dsl'

RSpec.describe 'Deserializer::DSL' do
  let(:deserializer) do
    Class.new do
      extend Deserializer::DSL
    end
  end

  it 'should let us set and retrieve a model to back with' do
    # Woah, meta
    deserializer.model(Deserializer)
    expect(deserializer.model).to eq(Deserializer)
  end

  it 'should let us set and retrieve what our key is' do
    deserializer.key(:id)
    expect(deserializer.key).to eq(:id)
  end

  it 'should stack up fields calls into one big thing and let us retrieve' do
    deserializer.fields :a, :b
    deserializer.fields :c, :d
    expect(deserializer.fields).to eq(%i[a b c d])
  end

  it 'should stack up conditions into one big thing and let us retrieve' do
    deserializer.conditions a: :test?
    deserializer.conditions b: :test?
    expect(deserializer.conditions.keys).to eq(%i[a b])
  end
end
