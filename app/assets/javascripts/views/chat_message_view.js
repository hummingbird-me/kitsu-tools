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

  notifier: function() {
    var myName = this.get('currentUser.username'),
        sender = this.get('content.username'),
        message = this.get('content.message'),
        self = this;

    Em.run.next(function() {
      if (self.$("a").filter(function() { return this.innerHTML == "@" + myName; }).length > 0) {
        var notification = new Notification("You were mentioned by " + sender, {
          body: message
        });
      }
    });
  }.observes('content.formattedMessage')
});
