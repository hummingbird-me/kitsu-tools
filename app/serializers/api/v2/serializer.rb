module Api::V2
  class Serializer
    attr_reader :object, :opts

    def initialize(object, opts={})
      @object = object
      @opts = opts
      if object.respond_to?(:to_ary)
        @strategy = ArraySerializationStrategy.new(self)
      else
        @strategy = ObjectSerializationStrategy.new(self)
      end
    end

    def title
      opts[:title] || self.class.instance_variable_get('@title')
    end

    def fields
      self.class.instance_variable_get('@fields')
    end

    def associations
      self.class.instance_variable_get('@associations')
    end

    def resource_fields
      @strategy.resource_fields
    end

    def associations
      @strategy.associations
    end

    def as_json
      json = {}
      json[@strategy.title] = resource_fields
      json
    end

    class << self
      def title(title)
        @title = title
      end

      def fields(*names)
        @fields ||= {id: nil}
        names.each do |name|
          @fields[name] = nil
        end
      end

      def field(name, &block)
        @fields ||= {id: nil}
        @fields[name] = block
      end

      def has_many(name, options, &block)
        if options[:serializer].nil?
          raise "#{self.to_s} #{name} association must specify serializer"
        end
        @associations ||= {}
        @associations[name] = {options: options, block: block}
      end
    end
  end
end
