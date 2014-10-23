HB.UserReviewsRoute = Ember.Route.extend(HB.Paginated, {
  fetchPage: function(page) {
    return this.store.find('review', {
      user_id: this.modelFor('user').get('id'),
      page: page
    });
  },
  
  afterModel: function() {
    return HB.TitleManager.setTitle(this.modelFor('user').get('username') + "'s Reviews");
  }
});
