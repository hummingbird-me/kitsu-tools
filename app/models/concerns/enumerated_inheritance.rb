module EnumeratedInheritance
  extend ActiveSupport::Concern

  module ClassMethods
    def sti_enum(classes = {})
      @sti_classes = classes
    end

    def sti_classes
      @sti_classes || superclass.try(:sti_classes) || {}
    end

    def find_sti_class(value)
      super if value.nil?
      sti_classes[value.to_i].constantize
    rescue NameError, TypeError
      super
    end

    def sti_name
      value = sti_classes.key(self.name)
      value.nil? ? super : value
    end
  end
end
