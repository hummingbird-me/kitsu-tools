Hummingbird.ChatRoute = Ember.Route.extend({
  model: function() {
    return [];
  },

  afterModel: function() {
    Hummingbird.TitleManager.setTitle("Chat");
  },

  activate: function() {
    var self = this;
    MessageBus.subscribe("/chat", function(message) {
      self.get('controller').send("recvMessage", message);
    });
  },

  deactivate: function() {
    MessageBus.unsubscribe("/chat");
  }
});
