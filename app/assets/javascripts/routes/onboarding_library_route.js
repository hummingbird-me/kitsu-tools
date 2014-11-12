HB.OnboardingLibraryRoute = Ember.Route.extend({
  
  model: function() {
    return Ember.RSVP.hash({
      anime: this.store.find('anime', { 'sort_by': 'user_count' }),
      manga: this.store.find('manga', { 'sort_by': 'created_at' }),
      library_entry: this.store.find('library_entry', { 'user_id': this.get('currentuser.id') })
    });
  }

});
