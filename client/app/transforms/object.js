import jQuery from 'jquery';
import Transform from 'ember-data/transform';

export default Transform.extend({
  deserialize(value) {
    return jQuery.isPlainObject(value) ? value : {};
  },

  serialize(value) {
    return this.deserialize(value);
  }
});
