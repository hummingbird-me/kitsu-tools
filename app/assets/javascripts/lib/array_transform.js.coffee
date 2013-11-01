Hummingbird.ArrayTransform = DS.Transform.extend
  serialize: (value) ->
    if Em.typeOf(value) == 'array'
      value
    else
      []

  deserialize: (value) ->
    value
