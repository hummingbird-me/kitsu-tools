module Api::V2
  class ObjectSerializer < Serializer
    def initialize(object, opts={})
      @object = object
      @opts = opts
    end

    def as_json
      json = { @@title => {} }
      @@fields.each do |name, block|
        value = block.nil? ? @object.send(name) : block.call(@object)
        value = value.blank? ? nil : value
        json[@@title][name] = value
      end
      json
    end
  end
end
