import Ember from 'ember';

export default Ember.Controller.extend({
  coverImageStyle: function() {
    let coverImage = this.get('model.coverImage');
    let coverImageOffset = this.get('model.coverImageTopOffset');
    return (`
      background-image: url('${coverImage}');
      background-position: 50% -${coverImageOffset}px;
    `).htmlSafe();
  }.property('model.coverImage', 'model.coverImageTopOffset'),

  amazonLink: function() {
    return "http://www.amazon.com/s/?field-keywords=" + encodeURIComponent(this.get('model.romajiTitle')) + "&tag=hummingbir0fe-20";
  }.property('model.romajiTitle'),

  mangaLibraryEntryExists: function() {
    return (!Ember.isNone(this.get('model.mangaLibraryEntry'))) && (!this.get('model.mangaLibraryEntry.isDeleted'));
  }.property('model.mangaLibraryEntry', 'model.mangaLibraryEntry.isDeleted')
});
