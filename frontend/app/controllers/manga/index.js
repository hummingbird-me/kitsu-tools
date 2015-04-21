import Ember from 'ember';
import HasCurrentUser from '../../mixins/has-current-user';

export default Ember.ObjectController.extend(HasCurrentUser, {
  mangaLibraryEntryExists: function() {
    return (!Ember.isNone(this.get('model.mangaLibraryEntry'))) && (!this.get('model.mangaLibraryEntry.isDeleted'));
  }.property('model.mangaLibraryEntry', 'model.mangaLibraryEntry.isDeleted')
});
