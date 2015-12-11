require 'json_expressions/rspec'

JsonExpressions::Matcher.assume_strict_arrays = false
JsonExpressions::Matcher.assume_strict_hashes = false

module JSONAPIMatchers
  def have_resource(attributes, type = nil, singular: true)
    data = { attributes: attributes, type: type }
    matcher = { data: (singular ? data : [data]) }
    match_json_expression(matcher)
  end

  def have_resources(attributes, type = nil)
    have_resource(attributes, type, singular: false)
  end

  def have_empty_resource
    matcher = { data: [].strict! }
    match_json_expression(matcher)
  end
end

RSpec.configure do |config|
  config.include JSONAPIMatchers
end
