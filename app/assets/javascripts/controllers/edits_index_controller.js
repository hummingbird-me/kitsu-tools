HB.EditsIndexController = Ember.ArrayController.extend({
  pendingAnime: function() {
    return this.get('content').filterBy('objectType', 'anime');
  }.property('@each')
});
