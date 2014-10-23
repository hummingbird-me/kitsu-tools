HB.UserFollowingRoute = Ember.Route.extend(HB.Paginated, {
  fetchPage: function(page) {
    return this.store.find('user', {
      followed_by: this.modelFor('user').get('id'),
      page: page
    });
  },
  
  afterModel: function() {
    return HB.TitleManager.setTitle("Followed by " + this.modelFor('user').get('username'));
  }
});
