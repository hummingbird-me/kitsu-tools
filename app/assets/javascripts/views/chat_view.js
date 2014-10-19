Hummingbird.ChatView = Ember.View.extend({
  scrollToBottom: function() {
    var chatItems = this.$('.chat-items');
    if (chatItems) {
      Em.run.next(function() {
        chatItems.scrollTop(chatItems.prop('scrollHeight'));
      });
    }
  }.observes('controller.content.@each')
});
