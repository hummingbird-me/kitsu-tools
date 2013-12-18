Hummingbird.MangaController = Ember.ObjectController.extend
  title: Ember.computed.any('model.romajiTitle', 'model.englishTitle')

  coverImageStyle: (->
    "background: url('" + @get('model.coverImage') + "'); background-position: 50% -" + @get('model.coverImageTopOffset') + "px;"
  ).property('model.coverImage', 'model.coverImageTopOffset')
