import { camelize } from 'ember-string';
import JSONAPISerializer from 'ember-data/serializers/json-api';

export default JSONAPISerializer.extend({
  keyForAttribute(key) {
    return camelize(key);
  },

  keyForRelationship(key) {
    return camelize(key);
  },

  serializeAttribute(snapshot, json, key) {
    if (key in snapshot.changedAttributes()) {
      return this._super(...arguments);
    }
  }
});
