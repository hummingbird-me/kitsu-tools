Hummingbird.MangaController = Ember.ObjectController.extend({
  title: Ember.computed.any('model.romajiTitle', 'model.englishTitle'),
  coverImageStyle: (function () {
    return "background: url('" + this.get('model.coverImage') + "'); background-position: 50% -" + this.get('model.coverImageTopOffset') + "px;";
  }).property('model.coverImage', 'model.coverImageTopOffset'),
  amazonLink: function() {
    return "http://www.amazon.com/s/?field-keywords=" + encodeURIComponent(this.get('model.romajiTitle')) + "&tag=hummingbir0fe-20";
  }.property('model.romajiTitle'),
  mangaLibraryExists: function() {
    return (!Ember.isNone(this.get('model.mangaLibrary')));
  }.property('model.mangaLibrary')
});
