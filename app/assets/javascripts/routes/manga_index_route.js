Hummingbird.MangaIndexRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('manga');
  },
  
  afterModel: function(resolvedModel) {
    return Hummingbird.TitleManager.setTitle(resolvedModel.get('romajiTitle'));
  }
});
