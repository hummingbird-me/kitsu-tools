Hummingbird.Paginated = Ember.Mixin.create({
  model: function() {
    return this.fetchPageProxy(1);
  },

  setControllerCanLoadMore: function() {
    this.setCanLoadMore(this.get('page') < this.get('total'));
  }.observes('page', 'total'),

  setupController: function(controller, model) {
    controller.set('canLoadMore', this.get('canLoadMore'));
    controller.set('model', model);
  },

  fetchPageProxy: function(page) {
    var that = this;
    this.set('currentlyFetchingPage', true);
    return this.fetchPage(page).then(function(objects) {
      that.set('page', parseInt(objects.get('meta.page')));
      that.set('total', parseInt(objects.get('meta.total')));
      Ember.run.next(function() {
        that.set('currentlyFetchingPage', false);
      });
      return objects;
    });
  },

  setCanLoadMore: function(canLoadMore) {
    this.set('canLoadMore', canLoadMore);
    if (this.controller) { this.controller.set('canLoadMore', canLoadMore); }
  },

  actions: {
    loadNextPage: function() {
      var that = this;
      if (this.get('canLoadMore') && !this.get('currentlyFetchingPage')) {
        this.fetchPageProxy(this.get('page')+1).then(function(objects) {
          that.controller.get('content').addObjects(objects);
        });
      }
    }
  }
});
