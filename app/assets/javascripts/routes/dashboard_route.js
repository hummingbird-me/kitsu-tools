Hummingbird.DashboardRoute = Ember.Route.extend(Hummingbird.Paginated, {
  fetchPage: function(page) {
    return this.store.find('story', {
      news_feed: true,
      page: page
    });
  },

  setupController: function(controller, model) {
    var currentUser = this.get('currentUser');
    controller.set('userInfo', this.store.find('userInfo', this.get('currentUser.id')));
    Hummingbird.TitleManager.setTitle("Dashboard");
    this.setCanLoadMore(true);
    controller.set('canLoadMore', true);
    return controller.set('model', []);
  }
});
