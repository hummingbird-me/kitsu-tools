import { JSONAPISerializer } from 'ember-cli-mirage';
import { camelize } from 'ember-string';

export default JSONAPISerializer.extend({
  keyForAttribute(key) {
    return camelize(key);
  },

  keyForRelationship(key) {
    return camelize(key);
  }
});
