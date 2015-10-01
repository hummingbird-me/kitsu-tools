class Deserializer
  ##
  # Mix into controllers for shorthand deserialization
  module Helper
    ##
    # Retrieve the JSON-API encoded object in the params and attempt to
    # deserialize it into a class based.
    #
    # If no class is specified, attempts to figure one out based on the current
    # controller's name.
    def deserialize(klass = nil, create: false)
      klass = default_deserializer unless klass
      klass.new(params, create: create).deserialize
    end

    private

    def default_deserializer
      type = self.class.name.sub('Controller', '').singularize
      "#{type}Deserializer".constantize
    end
  end
end
