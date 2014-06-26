Hummingbird.ReviewsIndexRoute = Ember.Route.extend(Hummingbird.Paginated, {
  fetchPage: function(page) {
    return this.store.find('review', {
      anime_id: this.modelFor('anime').get('id'),
      page: page
    });
  },
  
  afterModel: function(resolvedModel) {
    var anime = this.modelFor('anime');
    return Hummingbird.TitleManager.setTitle(anime.get('canonicalTitle') + " Reviews");
  }
});
