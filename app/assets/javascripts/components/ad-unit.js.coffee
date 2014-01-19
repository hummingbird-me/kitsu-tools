Hummingbird.AdUnitComponent = Ember.Component.extend
  adId: null
  adClass: null
  classNames: ['ad-unit']

  divId: (-> "bsap_" + @get('adId')).property('adId')
  divClass: (-> "bsarocks bsap_" + @get('adClass')).property('adClass')

  didInsertElement: ->
    if typeof(_bsap) != "undefined"
      _bsap.exec()
