Hummingbird.ChatMessageView = Ember.View.extend({
  messageHooks: function() {
    var self = this;
    if (this.get('content.formattedMessage')) {
      this.$('.spoiler').spoilerAlert();
      this.$('img').load(function() {
        self.get('parentView').send('rescroll');
      });
    }
  }.on('didInsertElement'),

  messageObserver: function() {
    Em.run.scheduleOnce('afterRender', this, 'messageHooks');
  }.observes('content.formattedMessage'),
});
