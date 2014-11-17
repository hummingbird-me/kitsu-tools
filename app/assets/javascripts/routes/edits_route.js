HB.EditsRoute = Ember.Route.extend(HB.Paginated, {
  preloadKey: "versions",
  preloadPath: "versions",
  preloadObject: "version",

  fetchPage: function(page) {
    return this.store.find('version', {
      state: 'pending',
      page: page
    });
  },

  afterModel: function(resolvedModel) {
    HB.TitleManager.setTitle('Pending Edits');
  }
})
