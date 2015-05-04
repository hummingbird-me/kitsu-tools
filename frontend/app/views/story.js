import Ember from 'ember';
import Suggester from '../utils/suggester';

export default Ember.View.extend({
  classNames: ["story"],

  templateName: function() {
    if (this.get('content.model.isDeleted')) {
      return "story/deleted";
    }
    return "story/" + this.get('content.model.type');
  }.property('content.model.type', 'content.model.isDeleted'),

  rerenderOnDeletion: function() {
    this.rerender();
  }.observes('content.model.isDeleted'),

  truncateLongComments: function() {
    var commentEl = this.$(".comment-text")[0];
    if (commentEl && commentEl.offsetHeight < commentEl.scrollHeight - 1) {
      this.controller.set('overflowing', true);
    }
  },

  hideSpoilers: function() {
    if (this.get('content.model.type') === "comment") {
      Ember.run.scheduleOnce('afterRender', this, function() {
        this.$(".spoiler").spoilerAlert();
      });
    }
  }.on('didInsertElement').observes('content.showAll', 'content.loadingAll'),

  didInsertElement: function() {
    var storyType = this.get('content.model.type');
    if (storyType === "comment") {
      this.truncateLongComments();
      this.$("img").load(() => {
        this.truncateLongComments();
      });

      Suggester(this.$('textarea'));
    }
  }
});
