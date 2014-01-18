Hummingbird.AnimeController = Ember.ObjectController.extend
  coverImageStyle: (->
    "background: url('" + @get('model.coverImage') + "'); background-position: 50% -" + @get('model.coverImageTopOffset') + "px;"
  ).property('model.coverImage', 'model.coverImageTopOffset')

  roundedBayesianRating: (->
    if @get('model.bayesianRating')
      @get('model.bayesianRating').toFixed(2)
    else
      null
  ).property('model.bayesianRating')

  trailerPreviewImage: (->
    "http://img.youtube.com/vi/" + @get('model.youtubeVideoId') + "/hqdefault.jpg"
  ).property('model.youtubeVideoId')

  libraryEntryExists: (->
    (not Ember.isNone(@get('model.libraryEntry'))) and (not @get('model.libraryEntry.isDeleted'))
  ).property('model.libraryEntry', 'model.libraryEntry.isDeleted')

  amazonLink: (->
    "http://www.amazon.com/s/?field-keywords=" + encodeURIComponent(@get('model.canonicalTitle')) + "&tag=hummingbir0fe-20"
  ).property('model.canonicalTitle')

  # Legacy -- remove after Ember transition is complete.
  newReviewURL: (-> "/anime/" + @get('model.id') + "/reviews/new").property('model.id')
  # End Legacy
