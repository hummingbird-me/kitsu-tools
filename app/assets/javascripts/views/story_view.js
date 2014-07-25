Hummingbird.StoryView = Ember.View.extend({
  classNames: ["story"],

  templateName: function() {
    if (this.get('content.isDeleted')) {
      return "story/deleted";
    }
    return "story/" + this.get('content.type');
  }.property('content.type', 'content.isDeleted'),

  rerenderOnDeletion: function() {
    this.rerender();
  }.observes('content.isDeleted'),

  truncateLongComments: function() {
    var commentEl = this.$(".comment-text")[0]
    if (commentEl.offsetHeight < commentEl.scrollHeight - 1) {
      this.controller.set('overflowing', true);
    }
  },

  didInsertElement: function() {
    var storyType = this.get('content.type'),
        self = this;

    if (storyType === "comment") {
      this.truncateLongComments();
      this.$("img").load(function() {
        self.truncateLongComments();
      });
    }
  }
});
