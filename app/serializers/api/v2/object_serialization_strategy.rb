require 'set'

module Api::V2
  class ObjectSerializationStrategy < SerializationStrategy
    def title
      @serializer.title
    end

    def identifier
      block = @serializer.fields[:id]
      block.nil? ? object.send(name) : block.call(object)
    end

    def as_json
      resource_fields = {}
      linked = {}
      json = {
        title => resource_fields,
        :linked => linked
      }

      # Normal fields
      @serializer.fields.each do |name, block|
        value = block.nil? ? object.send(name) : block.call(object)
        value = value.blank? ? nil : value
        resource_fields[name] = value
      end

      # Associations
      associations = []
      @serializer.associations.each do |name, config|
        options = config[:options]
        block = config[:block]

        value = block.nil? ? object.send(name) : block.call(object)
        serializer = options[:serializer].new(value,
                                              @serializer.opts.merge(options))

        resource_fields[:links] ||= {}
        resource_fields[:links][name] = serializer.strategy.identifier

        assoc_json = serializer.as_json
        assoc_title = serializer.strategy.title

        assoc_json[:linked] && linked.deep_merge!(assoc_json[:linked])

        plural_title = serializer.title.to_s.pluralize.to_sym
        linked[plural_title] ||= []
        if assoc_json[assoc_title].respond_to?(:to_ary)
          linked[plural_title] += assoc_json[assoc_title]
        else
          linked[plural_title] << assoc_json[assoc_title]
        end
      end

      json
    end
  end
end
