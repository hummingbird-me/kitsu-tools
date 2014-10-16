Hummingbird.DashboardRoute = Ember.Route.extend(Hummingbird.Paginated, {
  preloadKey: "dashboard_timeline",
  preloadPath: "stories",
  preloadObject: "story",

  activate: function() {
    var self = this;
    MessageBus.privateSubscribe("/newsfeed", function(story) {
      self.store.pushPayload(story);
      if (!self.get('controller.content').find(function(oldStory) { return parseInt(oldStory.get('id')) === story.story.id; })) {
        self.get('controller.newStories').pushObject(self.store.find('story', story.story.id));
      }
    });
  },

  deactivate: function() {
    MessageBus.privateUnsubscribe("/newsfeed");
  },

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
    if (model.length === 0) {
      this.set('cursor', null);
    }
    controller.set('model', model);

    if (model.get('length') === 0) {
      this.loadNextPage();
    }
  },

  actions: {
    goToDashboard: function() {
      this.refresh();
    },

    postComment: function(comment) {
      var story = this.store.createRecord('story', {
        type: 'comment',
        poster: this.get('currentUser.model.content'),
        user: this.get('currentUser.model.content'),
        comment: comment
      });
      this.currentModel.unshiftObject(story);
      story.save();
    },

    showNewStories: function() {
      this.set('controller.newStories', []);
      this.refresh();
    }
  }
});
