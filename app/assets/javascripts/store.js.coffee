# http://emberjs.com/guides/models/defining-a-store/

Hummingbird.Store = DS.Store.extend
  revision: 13
  adapter: '_ams'

Hummingbird.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'api/v2'

Hummingbird.ApplicationSerializer = DS.ActiveModelSerializer.extend
  serialize: (record, options) ->
    json = {}

    if options and options.includeId
      if record.get('id')
        json[this.get('primaryKey')] = record.get('id')

    changedAttributes = Object.keys record.get('_inFlightAttributes')

    record.eachAttribute (key, attribute) ->
      if changedAttributes.indexOf(key) != -1
        @serializeAttribute(record, json, key, attribute)
    , this

    record.eachRelationship (key, relationship) ->
      if relationship.kind == 'belongsTo'
        @serializeBelongsTo(record, json, relationship)
      else if relationship.kind == 'hasMany'
        @serializeHasMany(record, json, relationship)
    , this

    json

