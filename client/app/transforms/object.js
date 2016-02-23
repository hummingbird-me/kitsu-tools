import Ember from 'ember';
import Transform from 'ember-data/transform';

const {
  $: jQuery
} = Ember;

export default Transform.extend({
  deserialize(value) {
    return jQuery.isPlainObject(value) ? value : {};
  },

  serialize(value) {
    return this.deserialize(value);
  }
});
