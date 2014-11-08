HB.OnboardingCategoriesRoute = Ember.Route.extend({
  setupController: function(controller) {
    controller.set('loading', true);
    this.store.find('genre').then(function(genres) {
      controller.set('genres', genres.map(function(genre) {
        return Ember.Object.create({
          model: genre,
          favorite: false
        });
      }));
      controller.set('loading', false);
    });
  }
});
