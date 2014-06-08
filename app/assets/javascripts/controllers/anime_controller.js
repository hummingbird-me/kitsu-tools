Hummingbird.AnimeController = Ember.ObjectController.extend({
  coverImageStyle: function() {
    return "background: url('" + this.get('model.coverImage') + "'); background-position: 50% -" + this.get('model.coverImageTopOffset') + "px;";
  }.property('model.coverImage', 'model.coverImageTopOffset'),

  roundedBayesianRating: function() {
    if (this.get('model.bayesianRating')) {
      return this.get('model.bayesianRating').toFixed(2);
    } else {
      return null;
    }
  }.property('model.bayesianRating'),

  trailerPreviewImage: function() {
    return "http://img.youtube.com/vi/" + this.get('model.youtubeVideoId') + "/hqdefault.jpg";
  }.property('model.youtubeVideoId'),

  libraryEntryExists: function() {
    return (!Ember.isNone(this.get('model.libraryEntry'))) && (!this.get('model.libraryEntry.isDeleted'));
  }.property('model.libraryEntry', 'model.libraryEntry.isDeleted'),

  amazonLink: function() {
    return "http://www.amazon.com/s/?field-keywords=" + encodeURIComponent(this.get('model.canonicalTitle')) + "&tag=hummingbir0fe-20";
  }.property('model.canonicalTitle'),

  // Legacy -- remove after Ember transition is complete.
  newReviewURL: function() {
    return "/anime/" + this.get('model.id') + "/reviews/new";
  }.property('model.id')
  // End Legacy
});
