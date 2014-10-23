HB.MangaIndexRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('manga');
  },
  
  afterModel: function(resolvedModel) {
    return HB.TitleManager.setTitle(resolvedModel.get('romajiTitle'));
  }
});
