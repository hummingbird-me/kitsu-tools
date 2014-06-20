Hummingbird.UserFollowingRoute = Ember.Route.extend(Hummingbird.Paginated, {
  fetchPage: function(page) {
    return this.store.find('user', {
      followed_by: this.modelFor('user').get('id'),
      page: page
    });
  },
  
  afterModel: function() {
    return Hummingbird.TitleManager.setTitle("Followed by " + this.modelFor('user').get('username'));
  }
});
