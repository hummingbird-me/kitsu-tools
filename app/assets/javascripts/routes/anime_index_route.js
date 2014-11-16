HB.AnimeIndexRoute = Ember.Route.extend(HB.ResetScroll, {
  model: function() {
    return this.modelFor('anime');
  },

  setupController: function(controller, model) {
    if (model.get('featuredCastings.length') > 0) {
      // TODO Give English, Japanese preference here.
      controller.set('language', model.get('featuredCastings.content')[0].get('language'));
    }
    controller.set('model', model);
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
