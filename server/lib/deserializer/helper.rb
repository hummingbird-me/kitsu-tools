class Deserializer
  ##
  # Mix into controllers for shorthand deserialization
  module Helper
    ##
    # Retrieve a key from the params and attempt to deserialize it into a
    # class.
    #
    # If no class is specified, attempts to turn the key into a classname and
    # discover the same-named deserializer
    def deserialize(key, klass = nil, create: false)
      klass = "#{key.to_s.camelize}Deserializer".constantize unless klass
      klass.new(params.require(key), create: create).deserialize
    end
  end
end
