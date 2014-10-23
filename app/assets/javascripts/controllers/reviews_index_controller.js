HB.ReviewsIndexController = Ember.ArrayController.extend({
  needs: "anime",
  anime: Ember.computed.alias('controllers.anime'),
  sortProperties: ['wilsonScore'],
  sortAscending: false,

  // Legacy -- remove after Ember transition is complete.
  newReviewURL: function() {
    return "/anime/" + this.get('anime.id') + "/reviews/new";
  }.property('anime.id')
  // End Legacy
});
