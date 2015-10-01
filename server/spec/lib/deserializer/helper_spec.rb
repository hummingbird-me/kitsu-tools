require 'deserializer'
require 'deserializer/helper'

RSpec.describe 'Deserializer::Helper' do
  let(:deserializer) do
    Class.new(Deserializer) do
      def deserialize
        params
      end
    end
  end
  let(:controller) do
    Class.new do
      include Deserializer::Helper

      def params
        @params ||= ActionController::Parameters.new(
          data: {
            type: 'users',
            id: '1',
            attributes: { bar: 'baz' }
          }
        )
      end
    end
  end

  it 'should deserialize from params' do
    instance = controller.new
    foo = instance.deserialize(deserializer)
    expect(foo).to eq(instance.params)
  end
end
