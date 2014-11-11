module Api::V2
  class Serializer
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
