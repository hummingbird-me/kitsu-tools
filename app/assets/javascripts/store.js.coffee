# http://emberjs.com/guides/models/defining-a-store/

Hummingbird.Store = DS.Store.extend
  revision: 13
  adapter: '_ams'

Hummingbird.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'api/v2'

Hummingbird.ApplicationSerializer = DS.ActiveModelSerializer.extend({})

