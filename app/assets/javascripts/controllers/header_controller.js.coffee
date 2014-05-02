Hummingbird.HeaderController = Ember.Controller.extend
  newNotifications: Ember.computed.filterBy("notifications", "seen", false)
  showSearchbar: false

  panelNotifications: (->
    @store.all('notification')
  ).property('@each.notification')


  actions:
    toggleSearchbar: ->
      @toggleProperty('showSearchbar')
      false #prevent event-bubbling