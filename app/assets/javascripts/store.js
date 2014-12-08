HB.ApplicationStore = DS.Store.extend({});
HB.ApplicationAdapter = DS.ActiveModelAdapter.extend({});
HB.ApplicationSerializer = DS.ActiveModelSerializer.extend({});

// Custom ember-data DS attribute to serialize, and deserialize dates
// DS.attr('isodate')
// # => '1900-01-01'
HB.IsodateTransform = DS.Transform.extend({
  serialize: function(value) {
    return value ? moment(value).format('YYYY-MM-DD') : null;
  },

  deserialize: function(value) {
    return this.serialize(value);
  }
});
