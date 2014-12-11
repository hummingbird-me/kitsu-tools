import Ember from 'ember';

export default Ember.ArrayController.extend({
  removeReviewed: function() {
    this.get('content').filterBy('isDeleted').forEach(function(item) {
      this.removeAt(this.indexOf(item));
    }.bind(this));
  }.observes('@each.isDeleted')
});
