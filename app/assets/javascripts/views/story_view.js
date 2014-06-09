Hummingbird.StoryView = Ember.View.extend({
  templateName: function() {
    return "story/" + this.get('content.type');
  }.property('content.type')
});
