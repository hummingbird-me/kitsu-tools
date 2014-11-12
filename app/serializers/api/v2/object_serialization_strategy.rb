module Api::V2
  class ObjectSerializationStrategy < SerializationStrategy
    def title
      @serializer.title
    end

    # Return a hash of fields that are properties of the root resource.
    def resource_fields
      resource = {}
      @serializer.fields.each do |name, block|
        value = block.nil? ? object.send(name) : block.call(object)
        value = value.blank? ? nil : value
        resource[name] = value
      end
      resource
    end

    # Returns a hash with two keys: links and linked.
    def associations
      links = {}
      linked = {}
      @serializer.associations.each do |name, config|
        options = config[:options]
        block = config[:block]
        value = block.nil? ? object.send(name) : block.call(object)
        serializer = options[:serializer].new(value,
                                              @serializer.opts.merge(options))
      end
    end
  end
end
