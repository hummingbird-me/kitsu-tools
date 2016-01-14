import Ember from 'ember';
import Transform from 'ember-data/transform';

export default Transform.extend({
  deserialize(value) {
    if (Ember.$.isPlainObject(value)) {
      return value;
    }
    return {};
  },

  serialize(value) {
    return this.deserialize(value);
  }
});
