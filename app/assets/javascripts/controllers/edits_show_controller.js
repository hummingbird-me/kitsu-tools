HB.EditsShowController = Ember.Controller.extend({
  changes: function() {
    // todo: show html diff?
    return JSON.stringify(this.get('model.objectChanges'));
  }.property('model.objectChanges'),

  actions: {
    approveEdit: function() {
      this.get('model').save().then(function() {
        this.transitionToRoute('edits.index');
        Messenger().post('Edit was approved!');
      }.bind(this));
    },

    rejectEdit: function() {
      this.get('model').destroyRecord().then(function() {
        this.transitionToRoute('edits.index');
        Messenger().post('Edit was rejected.');
      }.bind(this));
    }
  }
});
