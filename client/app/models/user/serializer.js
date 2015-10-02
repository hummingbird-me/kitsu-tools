import DS from 'ember-data';

const { JSONAPISerializer } = DS;

export default JSONAPISerializer.extend({
  serializeAttribute(snapshot, json, key, attribute) {
    // skip if this isn't a new record
    if (snapshot.record.isNew === false) {
      return this._super(...arguments);
    }

    // remove null based attributes
    if (json.attributes !== undefined) {
      for (const k in json.attributes) {
        if (json.attributes[k] === null) {
          delete json.attributes[k];
        }
      }
    }
    return this._super(snapshot, json, key, attribute);
  }
});
