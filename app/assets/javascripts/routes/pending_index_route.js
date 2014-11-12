HB.PendingIndexRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('version', {
      state: 'pending'
    });
  },

  afterModel: function(resolvedModel) {
    var count = resolvedModel.get('length');
    HB.TitleManager.setTitle('Pending Edits (' + count + ')');
  }
})
