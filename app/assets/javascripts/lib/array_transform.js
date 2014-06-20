Hummingbird.ArrayTransform = DS.Transform.extend({
  serialize: function(value) {
    if (Em.typeOf(value) === 'array') {
      return value;
    } else {
      return [];
    }
  },
  deserialize: function(value) {
    return value;
  }
});
