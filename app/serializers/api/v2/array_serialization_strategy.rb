module Api::V2
  class ArraySerializationStrategy < SerializationStrategy
    def as_json
      object.map do |o|
        @serializer.class.new(o, @serializer.opts).as_json
      end
    end
  end
end
