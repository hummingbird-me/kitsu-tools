Hummingbird.ChatView = Ember.View.extend({
  scrollToBottom: function() {
    var chatItems = this.$('.chat-items');
    if (chatItems && (chatItems.prop('scrollTop') > (chatItems.prop('scrollHeight') - chatItems.innerHeight() * 1.5)) ) {
      Em.run.next(function() {
        chatItems.scrollTop(chatItems.prop('scrollHeight'));
      });
    }
  }.observes('controller.content.@each')
});
