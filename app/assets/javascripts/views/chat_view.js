Hummingbird.ChatView = Ember.View.extend({
  scrollToBottom: function() {
    // TODO
  }.observes('controller.content.@each')
});
