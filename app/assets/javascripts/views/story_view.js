Hummingbird.StoryView = Ember.View.extend({
  classNames: ["story"],

  templateName: function() {
    return "story/" + this.get('content.type');
  }.property('content.type')
});
