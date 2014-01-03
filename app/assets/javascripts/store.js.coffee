# http://emberjs.com/guides/models/defining-a-store/

Hummingbird.Store = DS.Store.extend
  revision: 13
  adapter: '_ams'

Hummingbird.ApplicationAdapter = DS.ActiveModelAdapter.extend({})

Hummingbird.ApplicationSerializer = DS.ActiveModelSerializer.extend({})
