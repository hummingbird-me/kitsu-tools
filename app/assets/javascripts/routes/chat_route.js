Hummingbird.ChatRoute = Ember.Route.extend({
  pingInterval: null,

  model: function() {
    return [];
  },

  afterModel: function() {
    Hummingbird.TitleManager.setTitle("Chat");
  },

  getOnlineUsers: function() {
    var self = this;
    return ic.ajax({
      url: "/chat/ping",
      type: 'POST'
    }).then(function(pingResponse) {
      console.log(pingResponse);
      self.set('controller.onlineUsers', pingResponse["online_users"]);
    });
  },

  activate: function() {
    var self = this;
    MessageBus.subscribe("/chat/lobby", function(message) {
      self.get('controller').send("recvMessage", message);
    });
    self.getOnlineUsers();
    self.set('pingInterval', setInterval(self.getOnlineUsers.bind(self), 20000));
  },

  deactivate: function() {
    MessageBus.unsubscribe("/chat");
    if (this.get('pingInterval')) {
      clearInterval(this.get('pingInterval'));
      this.set('pingInterval', null);
    }
  }
});
