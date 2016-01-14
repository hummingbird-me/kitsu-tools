import Ember from 'ember';
import Transform from 'ember-data/transform';

export default Transform.extend({
  deserialize(value) {
    if (Ember.isArray(value)) {
      return Ember.A(value);
    }
    return Ember.A();
  },

  serialize(value) {
    return this.deserialize(value);
  }
});
