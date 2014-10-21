Hummingbird.ChatRoute = Ember.Route.extend({
  pingInterval: null,

  model: function() {
    return [];
  },

  afterModel: function() {
    Hummingbird.TitleManager.setTitle("Chat");
  },

  ping: function() {
    var self = this;
    return ic.ajax({
      url: "/chat/ping",
      type: 'POST'
    }).then(function(pingResponse) {
      self.set('controller.onlineUsers', pingResponse.online_users);
      return pingResponse;
    });
  },

  activate: function() {
    //Notification.requestPermission();
    var self = this;
    self.ping().then(function(pingResponse) {
      var lastId = pingResponse.last_message_id - 40;
      if (lastId < 0) lastId = 0;
      MessageBus.subscribe("/chat/lobby", function(message) {
        self.get('controller').send("recvMessage", message);
      }, lastId);
    });
    self.set('pingInterval', setInterval(self.ping.bind(self), 20000));
  },

  deactivate: function() {
    MessageBus.unsubscribe("/chat");
    if (this.get('pingInterval')) {
      clearInterval(this.get('pingInterval'));
      this.set('pingInterval', null);
    }
  }
});
