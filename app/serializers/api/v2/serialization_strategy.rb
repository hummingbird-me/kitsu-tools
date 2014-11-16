module Api::V2
  class SerializationStrategy
    def initialize(serializer)
      @serializer = serializer
    end

    def title
      raise NotImplementedError
    end

    def identifier
      raise NotImplementedError
    end

    def as_json
      raise NotImplementedError
    end

    private

    def object
      @serializer.object
    end
  end
end
