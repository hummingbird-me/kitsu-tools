Hummingbird.ChatController = Ember.ArrayController.extend(Hummingbird.HasCurrentUser, {
  message: "",

  actions: {
    sendMessage: function() {
      var message = this.get('message');

      if (message.replace(/\s/g, '').length === 0) {
        return;
      }

      this.set('message', '');

      var messageObj = {
        id: "xxxxxxxxxxxxxxxxxxxxxx".replace(/[x]/g, function(c) { return (Math.random()*16|0).toString(16) }),
        message: message,
        username: this.get('currentUser.username')
      }

      ic.ajax({
        url: "/chat",
        type: "POST",
        data: messageObj
      }).then(Ember.K, function() {
        alert("Could not submit your message, something went wrong.");
      });

      this.send("recvMessage", messageObj);
    },

    recvMessage: function(message) {
      var self = this,
          messageObj = Ember.Object.create(message),
          newMessageFlag = true;

      this.get('model').forEach(function(oldMessage) {
        if (oldMessage.get('id') === messageObj.get('id')) {
          oldMessage.set('formattedMessage', messageObj.get('formatted_message'));
          oldMessage.set('delivered', messageObj.get('delivered'));
          newMessageFlag = false;
          return;
        }
      });

      if (newMessageFlag) {
        this.get('model').pushObject(messageObj);
      }
    }
  }
});
