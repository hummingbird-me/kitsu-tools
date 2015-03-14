import Ember from 'ember';
import ajax from 'ic-ajax';
/* global Messenger */

var REQUIRED_FAVORITE_COUNT = 2;

export default Ember.Controller.extend({
  totalFavorites: 0,

  remainingFavorites: function() {
    return REQUIRED_FAVORITE_COUNT - this.get('totalFavorites');
  }.property('totalFavorites'),

  canContinue: Ember.computed.gte('totalFavorites', REQUIRED_FAVORITE_COUNT),

  actions: {
    toggleFavorite: function(genre) {
      var self = this;
      if (genre.get('favorite')) {
        genre.set('favorite', false);
        ajax({
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
        ajax({
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
