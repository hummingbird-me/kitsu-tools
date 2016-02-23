import Ember from 'ember';
import Transform from 'ember-data/transform';

const {
  isArray
} = Ember;

export default Transform.extend({
  deserialize(value) {
    return isArray(value) ? value : [];
  },

  serialize(value) {
    return this.deserialize(value);
  }
});
