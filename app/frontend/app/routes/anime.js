import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('full-anime', params.id);
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
