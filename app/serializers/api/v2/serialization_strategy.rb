module Api::V2
  class SerializationStrategy
    def initialize(serializer)
      @serializer = serializer
    end

    private

    def title
      @serializer.title
    end

    def object
      @serializer.object
    end
  end
end
