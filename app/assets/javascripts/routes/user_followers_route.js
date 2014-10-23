HB.UserFollowersRoute = Ember.Route.extend(HB.Paginated, {
  fetchPage: function(page) {
    return this.store.find('user', {
      followers_of: this.modelFor('user').get('id'),
      page: page
    });
  },
  
  afterModel: function() {
    return HB.TitleManager.setTitle(this.modelFor('user').get('username') + "'s Followers");
  }
});
