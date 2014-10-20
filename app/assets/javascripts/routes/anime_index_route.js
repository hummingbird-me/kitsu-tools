Hummingbird.AnimeIndexRoute = Ember.Route.extend(Hummingbird.ResetScroll, {
  model: function() {
    return this.modelFor('anime');
  },

  afterModel: function(resolvedModel) {
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
