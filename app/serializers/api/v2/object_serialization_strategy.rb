module Api::V2
  class ObjectSerializationStrategy < SerializationStrategy
    def as_json
      title = @serializer.title
      object = @serializer.object
      json = { title => {} }
      @serializer.fields.each do |name, block|
        value = block.nil? ? object.send(name) : block.call(object)
        value = value.blank? ? nil : value
        json[title][name] = value
      end
      json
    end
  end
end
