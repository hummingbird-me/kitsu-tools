require 'deserializer/dsl'

##
# Deserialize parameters declaratively from JSONAPI
#
# = Example Payload
#
# {
#   data: {
#     type: 'users',
#     id: '1',
#     attributes: {
#       name: 'ikari_shinji',
#       bio: 'I HATE YOU DAD'
#     },
#     relationships: {
#       favorites: {
#         data: [
#           { type: 'anime', id: '5' },
#           { type: 'manga', id: '23' }
#         ]
#       }
#     }
#   }
# }
class Deserializer
  extend DSL

  ##
  # Initialize Deserializer with a permittable hash to apply against.  If the
  # hash is not permittable, this class will explode.  Seriously, don't do that
  def initialize(params, create: false)
    @params = params
    @create = create
  end

  ##
  # Return the attributes which survived being filtered by the class
  def filtered_attributes
    # => Attributes
    # Rename keys from kebab-case and camelCase to snake_case
    attrs = attributes.deep_transform_keys { |k| k.to_s.underscore.to_sym }
    attrs = attrs.slice(*self.class.fields)

    # For fields with conditions on them, check that they pass
    self.class.conditions.each do |key, condition|
      next unless attrs.key?(key)
      attrs.delete(key) unless passes_condition?(attrs[key], condition)
    end

    attrs.symbolize_keys
  end

  ##
  # Return the relationships which survived being filtered by the class
  def filtered_relationships
    # TODO
  end

  ##
  # Tell it to retrieve the object from the database and apply our changes hash
  # onto it and return the results
  def deserialize
    instance.assign_attributes(filtered_attributes)
    instance
  end

  private

  def instance
    @instance ||= create? ? self.class.model.new : self.class.model.find(id)
  end

  def passes_condition?(value, condition)
    condition = self.class.method(condition) if condition.is_a? Symbol
    # Limit to arity of recipient
    condition.call(*[value].take(condition.arity))
  end

  # Are we creating a new instance?
  def create?
    @create
  end

  attr_reader :params

  def data
    params[:data]
  end

  %i[type id attributes relationships].each do |name|
    define_method(name) { data[name] }
  end
end
