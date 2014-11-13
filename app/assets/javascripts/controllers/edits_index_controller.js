HB.EditsIndexController = Ember.ArrayController.extend({
  pendingAnime: function() {
    return this.get('content').filterBy('item.constructor.typeKey', 'anime');
  }.property('@each')
});
