module Api::V2
  class ArraySerializationStrategy < SerializationStrategy
    def title
      @serializer.title.to_s.pluralize.to_sym
    end

    def identifier
      block = @serializer.fields[:id]
      if block.nil?
        object.map {|x| x.id }
      else
        object.map {|x| block.call(x) }
      end
    end

    def as_json
      resource_fields = []
      linked = {}
      json = {
        title => resource_fields,
        :linked => linked
      }
      object.each do |item|
        serializer = @serializer.class.new(item, @serializer.opts)
        item_json = serializer.as_json
        resource_fields << item_json[serializer.strategy.title]
        linked.deep_merge!(item_json[:linked])
      end
      json
    end
  end
end
