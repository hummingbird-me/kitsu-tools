import DS from 'ember-data';

const { JSONAPISerializer } = DS;

export default JSONAPISerializer.extend({
  // We override `createRecord` here so when a user is created, we only push
  // the attributes that are changed, and not all.
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
