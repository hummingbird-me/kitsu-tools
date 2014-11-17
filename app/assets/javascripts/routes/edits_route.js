HB.EditsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('version', {
      state: 'pending'
    });
  },

  afterModel: function(resolvedModel) {
    HB.TitleManager.setTitle('Pending Edits');
  }
})
