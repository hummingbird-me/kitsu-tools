Hummingbird.AdUnitComponent = Ember.Component.extend
  adId: null
  adClass: null
  classNames: ['ad-unit']

  template: (context) ->
    id = "bsap_" + context.get('adId')
    className = "bsarocks bsap_" + context.get('adClass')
    bsaDiv = "<div id='" + id + "' class='" + className + "'></div>"
    bsaDiv

  didInsertElement: ->
    if typeof(_bsap) != "undefined"
      _bsap.exec()
