HB.ChatController = Ember.ArrayController.extend(HB.HasCurrentUser, {
  message: "",
  onlineUsers: [],

  command: function() {
    var msg = this.get('message');

    if (msg.indexOf('/') === 0) {
      var cmd = msg.slice(1, msg.indexOf(' '));
      if (['me', 'notice'].indexOf(cmd) !== -1) {
        return cmd;
      }
    }
  }.property('message'),

  commandMessage: function() {
    var msg = this.get('message');

    if (!this.get('command')) return msg;
    return msg.slice(msg.indexOf(' ')+1);
  }.property('command', 'message'),

  actions: {
    sendMessage: function() {
      var command = this.get('command');
      var message = this.get('commandMessage');

      if (message.replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0)
        return;

      this.set('message', '');

      var type = ({'me': 'action', 'notice': 'notice'})[command];
      type = type || 'message';

      var messageObj = {
        id: "xxxxxxxxxxxxxxxxxxxxxx".replace(/[x]/g, function(c) { return (Math.random()*16|0).toString(16) }),
        message: message,
        username: this.get('currentUser.username'),
        type: type
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
      case 'delete':
        this.get('model').forEach(function(oldMessage) {
          if (oldMessage.get('id') === messageObj.get('id')) {
            self.get('model').removeObject(oldMessage);
          }
        });
        break;
      default:
        this.get('model').forEach(function(oldMessage) {
          if (oldMessage.get('id') === messageObj.get('id')) {
            oldMessage.set('formattedMessage', messageObj.get('formattedMessage'));
            oldMessage.set('time', messageObj.get('time'));
            oldMessage.set('admin', messageObj.get('admin'));
            oldMessage.set('type', messageObj.get('type'));
            newMessageFlag = false;
            return;
          }
        });
        if (newMessageFlag) {
          this.get('model').pushObject(messageObj);
        }
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
