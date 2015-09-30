class Deserializer
  module DSL
    ##
    # Specifies which model we should attempt to deserialize into
    #
    # If no model is provided, returns the current model
    def model(model = nil)
      return @model unless model
      @model = model
    end

    ##
    # Specifies what attribute should be treated as the key and passed into the
    # model's `find` method.
    #
    # If no key is provided, returns the current key
    def key(key = nil)
      return @key unless key
      @key = key
    end

    ##
    # Specifies which attributes should be permitted
    def fields(*attrs)
      @attrs ||= []
      @attrs += attrs.flatten
      @attrs
    end

    ##
    # Specifies a condition for the permittance of a field
    #
    # If no hash is passed in, returns current conditions
    def conditions(hash = {})
      @conditions ||= {}
      @conditions.merge!(hash)
      @conditions
    end
  end
end
