import Ember from 'ember';
import JSONAPISerializer from 'ember-data/serializers/json-api';

const {
  String: { camelize }
} = Ember;

export default JSONAPISerializer.extend({
  keyForAttribute(key) {
    return camelize(key);
  },

  keyForRelationship(key) {
    return camelize(key);
  },

  // Serializes all attributes if the record is persistant (from the server)
  // or only serializes changed attributes when the record is new (local only)
  serializeAttribute(snapshot, json, key) {
    if (snapshot.record.isNew === false || key in snapshot.changedAttributes()) {
      return this._super(...arguments);
    }
  }
});
