import Ember from 'ember';
import DS from 'ember-data';

export default DS.Transform.extend({
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
