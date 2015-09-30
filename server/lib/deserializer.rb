require 'deserializer/dsl'

class Deserializer
  extend DSL

  ##
  # Initialize Deserializer with a permittable hash to apply against.  If the
  # hash is not permittable, this class will explode.  Seriously, don't do that
  def initialize(hash, create: false)
    @hash = hash
    @create = create
  end

  ##
  # Filter attributes from the parameters and apply them to the attrs hash
  def filter
    # Rename keys from kebab-case and camelCase to snake_case
    attrs = @hash.deep_transform_keys { |k| k.to_s.underscore }
    attrs = ActionController::Parameters.new(attrs)

    attrs = attrs.permit(self.class.fields)

    # For fields with conditions on them, check that they pass
    self.class.conditions.each do |key, condition|
      next unless attrs.key?(key)
      attrs.delete(key) unless passes_condition?(key, condition)
    end

    attrs.symbolize_keys
  end

  ##
  # Tell it to retrieve the object from the database and apply our changes hash
  # onto it and return the results
  def deserialize
    instance.assign_attributes(filter)
    instance
  end

  private

  def instance
    @instance ||= create? ? self.class.model.new : self.class.model.find(id)
  end

  def passes_condition?(key, condition)
    condition = self.class.method(condition) if condition.is_a? Symbol
    args = [@hash[key]]
    arity = condition.arity
    condition.call(*args.take(arity))
  end

  # Are we creating a new instance?
  def create?
    @create
  end

  def id
    @hash[self.class.key]
  end
end
