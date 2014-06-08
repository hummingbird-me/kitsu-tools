Hummingbird.MangaController = Ember.ObjectController.extend({
  title: Ember.computed.any('model.romajiTitle', 'model.englishTitle'),
  coverImageStyle: (function () {
    return "background: url('" + this.get('model.coverImage') + "'); background-position: 50% -" + this.get('model.coverImageTopOffset') + "px;";
  }).property('model.coverImage', 'model.coverImageTopOffset')
});
