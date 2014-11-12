HB.OnboardingLibraryRoute = Ember.Route.extend({

  setupController: function(controller) {
    controller.set('loading', true);

    var promises = {
      anime: this.store.find('anime', { 'sort_by': 'user_count', 'sort_reverse': true }),
      manga: this.store.find('manga', { 'sort_by': 'created_at', 'sort_reverse': true }),
      libraryEntries: this.store.find('library_entry', { 'user_id': this.get('currentUser.id') }),
      mangaLibraryEntries: this.store.find('manga_library_entry', { 'user_id': this.get('currentUser.id') })
    }

    Ember.RSVP.hash(promises).then(function(hash){
      controller.setProperties({
        'content': hash,
        'importFromMal': false,
        'totalRatings': (parseInt(hash.libraryEntries.get('length')) + parseInt(hash.mangaLibraryEntries.get('length'))),
        'loading': false
      });
    });
  }

});
