Hummingbird.AnimeIndexRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('anime');
  },

  afterModel: function(resolvedModel) {
    Ember.run.next(function() {
      return window.scrollTo(0, 0);
    });
    return Hummingbird.TitleManager.setTitle(resolvedModel.get('displayTitle'));
  },

  actions: {
    toggleQuoteFavorite: function(quote) {
      quote.set('isFavorite', !quote.get('isFavorite'));
      return quote.save().then(Ember.K, function() {
        return quote.rollback();
      });
    }
  }
});
