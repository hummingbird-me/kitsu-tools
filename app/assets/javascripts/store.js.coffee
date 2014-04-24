# http://emberjs.com/guides/models/defining-a-store/

Hummingbird.Store = DS.Store.extend
  revision: 13
  adapter: '_ams'

Hummingbird.ApplicationAdapter = DS.ActiveModelAdapter.extend({})

Hummingbird.ApplicationSerializer = DS.ActiveModelSerializer.extend({})

# Custom data type: Array
DS.JSONTransforms.array =
  serialize: (jsonData)->
    if Em.typeOf(jsonData) is 'array' then jsonData else []

  deserialize: (externalData)->
    switch Em.typeOf(externalData)
      when 'array'  then return externalData
      when 'string' then return externalData.split(',').map((item)-> jQuery.trim(item))
      else               return []
