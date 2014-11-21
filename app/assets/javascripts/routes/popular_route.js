HB.PopularRoute = Ember.Route.extend(HB.Paginated, {
  fetchPage: function(page) {
    return this.store.find('story', {
      popular: true,
      page: page
    });
  },

  setupController: function(controller, model) {
    this.setCanLoadMore(true);
    controller.set('canLoadMore', true);
    controller.set('model', model);
    this.loadNextPage();
  }
});
