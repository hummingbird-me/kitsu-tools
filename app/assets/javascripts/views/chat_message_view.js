Hummingbird.ChatMessageView = Ember.View.extend({
  messageHooks: function() {
    var self = this;
    if (this.get('content.formattedMessage')) {
      this.$('.spoiler').spoilerAlert();
      this.$('img').load(function() {
        self.get('parentView').send('rescroll');
      });
    }
  },

  // didInsertElement is post-DOM, messageObserver is pre-DOM
  // So they're separated like this
  didInsertElement: function() {
    this.messageHooks();
  },

  messageObserver: function() {
    var self = this;
    Em.run.next(function() {
      self.messageHooks();
    });
  }.observes('content.formattedMessage'),

  click: function(e) {
    if ($(e.target).parents('a').length == 0) {
      this.get('controller').send('replyUser', this.get('content.username'));
    }
  }
});
