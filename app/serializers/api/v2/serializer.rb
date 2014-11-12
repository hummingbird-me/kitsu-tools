module Api::V2
  class Serializer
    def initialize(object, opts={})
      @object = object
      @opts = opts
      if object.respond_to?(:to_ary)
        @strategy = ArraySerializationStrategy.new(self)
      else
        @strategy = ObjectSerializationStrategy.new(self)
      end
    end

    def object
      @object
    end

    def title
      @@title
    end

    def fields
      @@fields
    end

    def as_json
      @strategy.as_json
    end

    class << self
      def title(title)
        @@title = title
      end

      def fields(*names)
        @@fields ||= {}
        names.each do |name|
          @@fields[name] = nil
        end
      end

      def field(name, &block)
        @@fields ||= {}
        @@fields[name] = block
      end
    end
  end
end
