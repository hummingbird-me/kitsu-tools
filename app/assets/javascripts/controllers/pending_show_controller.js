HB.PendingShowController = Ember.Controller.extend({
  changes: function() {
    // todo: show html diff?
    return JSON.stringify(this.get('model.objectChanges'));
  }.property('model.objectChanges'),

  actions: {
    approveEdit: function() {
      // todo
    },

    rejectEdit: function() {
      // todo
    }
  }
});
