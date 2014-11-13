HB.EditsShowRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('version', params.id);
  },

  afterModel: function(resolvedModel) {
    var name = resolvedModel.get('user.username');
    HB.TitleManager.setTitle('Pending Edit by ' + name);
  }
})
