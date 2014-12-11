import DS from 'ember-data';

export default DS.Transform.extend({
  deserialize: function(serialized) {
    return serialized;
  },

  serialize: function(deserialized) {
    if (deserialized instanceof Array) {
      return deserialized;
    } else {
      return [];
    }
  }
});
