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

    def identifier
      block = fields[:id]
      if @object.respond_to?(:to_ary)
        @object.map {|o| block.nil? ? o.send(:id) : block.call(o) }
      else
        block.nil? ? @object.send(:id) : block.call(@object)
      end
    end

    def fields
      self.class.instance_variable_get('@fields') || {}
    end

    def associations
      self.class.instance_variable_get('@associations') || {}
    end

    def as_json
      @strategy.as_json
    end

    class << self
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
