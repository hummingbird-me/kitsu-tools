Hummingbird.ChatMessageView = Ember.View.extend({
  messageHooks: function() {
    var self = this;
    if (this.get('content.formattedMessage')) {
      this.$('.spoiler').spoilerAlert();
    }
  },
});
