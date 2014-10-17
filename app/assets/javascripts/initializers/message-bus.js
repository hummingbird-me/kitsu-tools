Ember.Application.initializer({
  name: 'message-bus',
  after: 'preload',

  initialize: function() {
    var bus = MessageBus,
        privateChannel = Hummingbird.PreloadStore.get("private_channel");

    bus.privateSubscribe = function(channel, callback) {
      if (privateChannel) {
        bus.subscribe("/" + privateChannel + channel, callback);
      }
    };

    bus.privateUnsubscribe = function(channel) {
      if (privateChannel) {
        bus.unsubscribe("/" + privateChannel + channel);
      }
    }

    bus.callbackInterval = 500;
    bus.start();
  }
});
