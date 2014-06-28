Hummingbird.MangaController = Ember.ObjectController.extend(Hummingbird.HasCurrentUser, {
  title: Ember.computed.any('model.romajiTitle', 'model.englishTitle'),

  coverImageStyle: function () {
    return "background: url('" + this.get('model.coverImage') + "'); background-position: 50% -" + this.get('model.coverImageTopOffset') + "px;";
  }.property('model.coverImage', 'model.coverImageTopOffset'),

  amazonLink: function() {
    return "http://www.amazon.com/s/?field-keywords=" + encodeURIComponent(this.get('model.romajiTitle')) + "&tag=hummingbir0fe-20";
  }.property('model.romajiTitle'),

  mangaLibraryEntryExists: function() {
    return (!Ember.isNone(this.get('model.mangaLibraryEntry')));
  }.property('model.mangaLibraryEntry')
});
