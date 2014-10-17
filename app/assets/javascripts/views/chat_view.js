Hummingbird.ChatView = Ember.View.extend({
  scrollToBottom: function() {
    $('.chat-items').scrollTop($('.chat-items').prop('scrollHeight'));
  }.observes('controller.content.@each')
});
