Hummingbird.ChatView = Ember.View.extend({
  scrollToBottom: function() {
    var self = this;
    Em.run.next(function() {
      self.send('rescroll');
    });
  }.observes('controller.content.@each'),
  actions: {
    rescroll: function() {
      var chatItems = this.$('.chat-items');
      if (!chatItems) return;

      // Distance between bottom of visible part and the bottom of the scrollable pane
      var stickyOffset = chatItems.prop('scrollHeight') - chatItems.innerHeight() * 0.5;
      var scrollBottom = chatItems.prop('scrollTop') + chatItems.innerHeight();

      if (scrollBottom > stickyOffset) {
        chatItems.scrollTop(chatItems.prop('scrollHeight'));
      }
    }
  }
});
