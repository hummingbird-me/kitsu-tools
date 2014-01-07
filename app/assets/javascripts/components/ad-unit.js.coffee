Hummingbird.AdUnitComponent = Ember.Component.extend
  width: 729
  height: 90
  client: "ca-pub-3410319844519574"
  slot: "9428733249"

  adStyle: (->
    "display:inline-block;width:" + @get('width') + "px;height:" + @get('height') + "px"
  ).property('width', 'height')

  didInsertElement: ->
    (adsbygoogle = window.adsbygoogle || []).push({});
