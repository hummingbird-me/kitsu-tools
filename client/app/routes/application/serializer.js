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
  },

  // Serializes all attributes if the record is persistant (from the server)
  // or only serializes changed attributes when the record is new (local only)
  serializeAttribute(snapshot, json, key) {
    if (snapshot.record.isNew === false || key in snapshot.changedAttributes()) {
      return this._super(...arguments);
    }
  }
});
