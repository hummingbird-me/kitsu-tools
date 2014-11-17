HB.EditsController = Ember.ArrayController.extend({
  isDiffShown: false,

  pendingAnime: function() {
    return this.get('content').filterBy('objectType', 'anime');
  }.property('@each'),

  removeReviewed: function() {
    this.get('content').filterBy('isDeleted').forEach(function(item) {
      this.removeAt(this.indexOf(item));
    }.bind(this));
  }.observes('@each.isDeleted')
});
