import Ember from 'ember';
import DS from 'ember-data';

const { String: { camelize } } = Ember;
const { JSONAPISerializer } = DS;

export default JSONAPISerializer.extend({
  keyForAttribute(key) {
    return camelize(key);
  },

  keyForRelationship(key) {
    return camelize(key);
  }
});
