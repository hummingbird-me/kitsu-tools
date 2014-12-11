import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';

export default Ember.ObjectController.extend(HasCurrentUser, {
  coverImageStyle: function() {
    return "background-image: url('" + this.get('model.coverImage') + "'); background-position: 50% -" + this.get('model.coverImageTopOffset') + "px;";
  }.property('model.coverImage', 'model.coverImageTopOffset'),

  amazonLink: function() {
    return "http://www.amazon.com/s/?field-keywords=" + encodeURIComponent(this.get('model.romajiTitle')) + "&tag=hummingbir0fe-20";
  }.property('model.romajiTitle'),

  mangaLibraryEntryExists: function() {
    return (!Ember.isNone(this.get('model.mangaLibraryEntry'))) && (!this.get('model.mangaLibraryEntry.isDeleted'));
  }.property('model.mangaLibraryEntry', 'model.mangaLibraryEntry.isDeleted')
});
