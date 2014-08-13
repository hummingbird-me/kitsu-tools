Hummingbird.AnimeController = Ember.ObjectController.extend(Hummingbird.HasCurrentUser, {
  coverImageStyle: function() {
    return "background: url('" + this.get('model.coverImage') + "'); background-position: 50% -" + this.get('model.coverImageTopOffset') + "px;";
  }.property('model.coverImage', 'model.coverImageTopOffset'),

  trailerPreviewImage: function() {
    return "http://img.youtube.com/vi/" + this.get('model.youtubeVideoId') + "/hqdefault.jpg";
  }.property('model.youtubeVideoId'),

  libraryEntryExists: function() {
    return (!Ember.isNone(this.get('model.libraryEntry'))) && (!this.get('model.libraryEntry.isDeleted'));
  }.property('model.libraryEntry', 'model.libraryEntry.isDeleted'),

  // Legacy -- remove after Ember transition is complete.
  newReviewURL: function() {
    return "/anime/" + this.get('model.id') + "/reviews/new";
  }.property('model.id'),
  fullQuotesURL: function () {
    return "/anime/" + this.get('model.id') + "/quotes";
  }.property('model.id'),
  fullReviewsURL: function () {
    return "/anime/" + this.get('model.id') + "/reviews";
  }.property('model.id')
  // End Legacy
});
