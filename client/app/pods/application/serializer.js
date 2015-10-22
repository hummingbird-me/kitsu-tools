import Ember from 'ember';
import DS from 'ember-data';

const { String: { underscore } } = Ember;
const { JSONAPISerializer } = DS;

export default JSONAPISerializer.extend({
  keyForAttribute(key) {
    return underscore(key);
  },

  keyForRelationship(key) {
    return underscore(key);
  }
});
