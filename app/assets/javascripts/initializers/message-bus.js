Ember.Application.initializer({
  name: 'message-bus',

  initialize: function() {
    var bus = MessageBus;
    bus.callbackInterval = 5000;
    bus.enableLongPolling = true;
  }
});
