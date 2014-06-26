Hummingbird.AwesomeRatingComponent = Ember.Component.extend({
  classNames: ["awesome-rating-widget"],
  type: "advanced",
  editable: false,
  rating: null,


  applyAwesomeRating: function() {
    var _this = this;
    return this.$().AwesomeRating({
      rating: this.get('rating'),
      type: this.get('type'),
      editable: this.get('editable'),
      update: function(newRating) {
        _this.sendAction('action', newRating);
        return _this.set('rating', newRating);
      }
    });
  }.on('didInsertElement').observes('rating')
});
