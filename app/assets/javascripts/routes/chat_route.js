Hummingbird.ChatRoute = Ember.Route.extend({
  model: function() {
    return [];
  },

  afterModel: function() {
    Hummingbird.TitleManager.setTitle("Chat");
  },

  activate: function() {
    var self = this;
    //MessageBus.subscribe("/chat", function(data) {
    //  self.get('controller.model').pushObject(data);
    //});
  },

  deactivate: function() {
    //MessageBus.unsubscribe("/chat");
  }
});
