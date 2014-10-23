Ember.Application.initializer({
  name: 'message-bus',
  after: 'preload',

  initialize: function() {
    var bus = MessageBus,
        privateChannel = HB.PreloadStore.get("private_channel");

    bus.start();
  }
});
