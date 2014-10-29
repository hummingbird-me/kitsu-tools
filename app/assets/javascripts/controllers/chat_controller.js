HB.ChatController = Ember.ArrayController.extend(HB.HasCurrentUser, {
  message: "",
  onlineUsers: [],

  actions: {
    sendMessage: function() {
      var message = this.get('message');

      if (message.replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0)
        return;

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

    deleteMessage: function(id) {
      ic.ajax({
        url: "/chat",
        type: "DELETE",
        data: { id: id }
      }).then(Ember.K, function() {
        alert("Could not delete this message, something went wrong.");
      });
    },

    recvMessage: function(message) {
      var self = this,
          messageObj = Ember.Object.create(message),
          newMessageFlag = true;

      switch (messageObj.get('type')) {
      case 'message':
        this.get('model').forEach(function(oldMessage) {
          if (oldMessage.get('id') === messageObj.get('id')) {
            oldMessage.set('formattedMessage', messageObj.get('formattedMessage'));
            oldMessage.set('time', messageObj.get('time'));
            oldMessage.set('admin', messageObj.get('admin'));
            newMessageFlag = false;
            return;
          }
        });
        if (newMessageFlag) {
          this.get('model').pushObject(messageObj);
        }
        break;
      case 'delete':
        this.get('model').forEach(function(oldMessage) {
          if (oldMessage.get('id') === messageObj.get('id')) {
            self.get('model').removeObject(oldMessage);
          }
        });
      }
    },

    replyUser: function(username) {
      var msg = this.get('message');

      if (msg.length > 0) msg += ' ';
      msg += '@' + username + ' ';
      this.set('message', msg);
      $('#chat-input').focus();
    }
  }
});
