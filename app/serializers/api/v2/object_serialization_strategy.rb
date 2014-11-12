require 'set'

module Api::V2
  class ObjectSerializationStrategy < SerializationStrategy
    def as_json
      json = {}

      # Normal fields
      @serializer.fields.each do |name, block|
        value = block.nil? ? object.send(name) : block.call(object)
        value = value.blank? ? nil : value
        json[name] = value
      end

      # Associations
      @serializer.associations.each do |name, config|
        options = config[:options]
        block = config[:block]
        value = block.nil? ? object.send(name) : block.call(object)
        serializer = options[:serializer].new(value,
                                              @serializer.opts.merge(options))
        json[name] = serializer.as_json
      end

      json
    end
  end
end
