import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ["awesome-rating-widget"],
  type: "advanced",
  editable: false,
  rating: null,
  media: null,

  applyAwesomeRating: function() {
    var self = this;
    this.$().AwesomeRating({
      rating: this.get('rating'),
      type: this.get('type'),
      editable: this.get('editable'),
      update: function(newRating) {
        self.sendAction('action', newRating, self.get('media'));
        self.set('rating', newRating);
      }
    });
  }.on('didInsertElement').observes('rating')
});
