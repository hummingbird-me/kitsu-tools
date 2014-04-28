Hummingbird.HeaderController = Ember.Controller.extend
  newNotifications: Ember.computed.filterBy("notifications", "seen", false)

  panelNotifications: (->
    @store.all('notification')
  ).property('@each.notification')