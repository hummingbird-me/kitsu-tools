HB.AnimeRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('fullAnime', params.id);
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
