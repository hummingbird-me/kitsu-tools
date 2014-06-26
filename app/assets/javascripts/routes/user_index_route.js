Hummingbird.UserIndexRoute = Ember.Route.extend(Hummingbird.Paginated, {
  enter: function() {
    return this.controllerFor('application').send("setupQuickUpdate");
  },

  fetchPage: function(page) {
    return this.store.find('story', {
      user_id: this.modelFor('user').get('id'),
      page: page
    });
  },

  setupController: function(controller, model) {
    controller.set('userInfo', this.store.find('userInfo', this.modelFor('user').get('id')));
    Ember.$.ajax({
      url: '/api/v1/users/' + this.modelFor('user').get('id') + '/favorite_anime',
      type: 'GET',
      success: function(payload) {
        return controller.set('favorite_anime', payload);
      },
      failure: function() {
        return console.log('failed to retrieve favorite anime');
      }
    });
    this.setCanLoadMore(true);
    controller.set('canLoadMore', true);
    return controller.set('model', []);
  },
  
  afterModel: function() {
    Ember.run.next(function() {
      return window.scrollTo(0, 0);
    });
    return Hummingbird.TitleManager.setTitle(this.modelFor('user').get('username') + "'s Profile");
  }
});
