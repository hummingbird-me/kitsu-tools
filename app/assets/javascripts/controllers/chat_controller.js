Hummingbird.ChatController = Ember.ArrayController.extend(Hummingbird.HasCurrentUser, {
  message: "",

  actions: {
    sendMessage: function() {
      var message = this.get('message');

      if (message.replace(/\s/g, '').length === 0) {
        return;
      }

      this.set('message', '');

      ic.ajax({
        url: "/chat",
        type: "POST",
        data: {
          message: message
        }
      }).then(Ember.K, function() {
        alert("Could not submit your message, something went wrong.");
      });
    }
  }
});
