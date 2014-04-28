Hummingbird.HeaderController = Ember.Controller.extend
  notificationNew: (->
    '04'
  ).property('notification')

  notifications: (->
    @store.find('notification')
  ).property('@each.notification')