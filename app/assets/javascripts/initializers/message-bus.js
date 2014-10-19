Ember.Application.initializer({
  name: 'message-bus',
  after: 'preload',

  initialize: function() {
    var bus = MessageBus,
        privateChannel = Hummingbird.PreloadStore.get("private_channel");

    bus.callbackInterval = 500;
    bus.start();
  }
});
