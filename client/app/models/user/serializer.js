import ApplicationSerializer from 'client/pods/application/serializer';

export default ApplicationSerializer.extend({
  // Serializes all attributes if the record is persistant (from the server)
  // or only serializes changed attributes when the record is new (local only)
  serializeAttribute(snapshot, json, key) {
    if (snapshot.record.isNew === false || key in snapshot.changedAttributes()) {
      return this._super(...arguments);
    }
  }
});
