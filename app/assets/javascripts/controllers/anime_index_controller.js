Hummingbird.AnimeIndexController = Ember.ObjectController.extend(Hummingbird.HasCurrentUser, {
  showEpisodes: function() {
    return this.get('currentUser.isAdmin');
  }.property('currentUser.isAdmin'),

  // Legacy -- remove after Ember transition is complete.
  newReviewURL: function() {
    return "/anime/" + this.get('model.id') + "/reviews/new";
  }.property('model.id'),
  fullReviewsURL: function () {
    return "/anime/" + this.get('model.id') + "/reviews";
  }.property('model.id'),
  // End Legacy
});
