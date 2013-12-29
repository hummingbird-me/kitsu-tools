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

