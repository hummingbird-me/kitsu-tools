HB.AnimeIndexRoute = Ember.Route.extend(HB.ResetScroll, {
  model: function() {
    return this.modelFor('anime');
  },

  afterModel: function(resolvedModel) {
    return HB.TitleManager.setTitle(resolvedModel.get('displayTitle'));
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
