Hummingbird.DashboardRoute = Ember.Route.extend(Hummingbird.Paginated, {
  fetchPage: function(page) {
    var self = this,
        store = this.store;

    var finder = function() {
      return self.store.find('story', {
        news_feed: true,
        page: page
      });
    };

    if (page == 1) {
      // TODO need a common pattern for this.
      var finderED = finder;
      finder = function() {
        return Hummingbird.PreloadStore.popAsync('dashboard_timeline', finderED).then(function(stories) {
          if (typeof stories["stories"] === "undefined") {
            return stories;
          } else {
            store.pushPayload(stories);
            var ids = stories["stories"].map(function(x) { return x.id });
            return store.findByIds('story', ids);
          }
        });
      };
    }

    return finder();
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
