# http://emberjs.com/guides/models/defining-a-store/

Hummingbird.ApplicationAdapter = DS.RESTAdapter.extend
  namespace: 'api/v2'

Hummingbird.ApplicationSerializer = DS.ActiveModelSerializer.extend({})

