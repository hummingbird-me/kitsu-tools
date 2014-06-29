Ember.Application.initializer({
  name: 'message-bus',

  initialize: function() {
    var bus = MessageBus;
    bus.callbackInterval = 500;
    bus.enableLongPolling = true;
  }
});
