import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ["awesome-rating-widget"],
  type: "advanced",
  editable: false,
  rating: null,
  media: null,

  applyAwesomeRating: function() {
    this.$().AwesomeRating({
      rating: this.get('rating'),
      type: this.get('type'),
      editable: this.get('editable'),
      update: (newRating) => {
        if (this.get('rating') === newRating) {
          newRating = null;
        }
        this.sendAction('action', newRating, this.get('media'));
      }
    });
  }.on('didInsertElement').observes('rating')
});
