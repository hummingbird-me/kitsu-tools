HB.EditsController = Ember.ArrayController.extend({
  isDiffShown: false,
  
  pendingAnime: function() {
    return this.get('content').filterBy('objectType', 'anime');
  }.property('@each')
});
