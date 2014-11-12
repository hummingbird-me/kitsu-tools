HB.OnboardingLibraryRoute = Ember.Route.extend({
  
  model: function() {
    return Ember.RSVP.hash({
      anime: this.store.find('anime', { 'sort_by': 'user_count' }),
      manga: this.store.find('manga', { 'sort_by': 'created_at' }),
    });
  }

});
