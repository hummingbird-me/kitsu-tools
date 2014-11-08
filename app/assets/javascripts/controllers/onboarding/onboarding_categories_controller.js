var REQUIRED_FAVORITE_COUNT = 2;

HB.OnboardingCategoriesController = Ember.Controller.extend({
  totalFavorites: 0,

  remainingFavorites: function() {
    return REQUIRED_FAVORITE_COUNT - this.get('totalFavorites');
  }.property('totalFavorites'),

  canContinue: Em.computed.gte('totalFavorites', REQUIRED_FAVORITE_COUNT),

  actions: {
    toggleFavorite: function(genre) {
      var self = this;
      if (genre.get('favorite')) {
        genre.set('favorite', false);
        ic.ajax({
          url: "/genres/" + genre.get('model.id') + "/remove_from_favorites",
          type: 'POST'
        }).then(function() {
          self.decrementProperty('totalFavorites');
        }, function() {
          genre.set('favorite', true);
          Messenger().post("Something went wrong.");
        });
      } else {
        genre.set('favorite', true);
        ic.ajax({
          url: "/genres/" + genre.get('model.id') + "/add_to_favorites",
          type: 'POST'
        }).then(function() {
          self.incrementProperty('totalFavorites');
        }, function() {
          genre.set('favorite', false);
          Messenger().post("Something went wrong.");
        });
      }
    }
  }
});
