HB.DashboardRoute = Ember.Route.extend(HB.Paginated, {
  preloadKey: "dashboard_timeline",
  preloadPath: "stories",
  preloadObject: "story",

  activate: function() {
    var self = this;
    MessageBus.subscribe("/newsfeed", function(story) {
      story = JSON.parse(story);
      self.store.pushPayload(story);
      if (!self.get('controller.newStories').find(function(oldStory) { return parseInt(oldStory.get('id')) === story.story.id; })) {
        self.get('controller.newStories').pushObject(self.store.find('story', story.story.id));
      }
    });
  },

  deactivate: function() {
    MessageBus.unsubscribe("/newsfeed");
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
    HB.TitleManager.setTitle("Dashboard");
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
      if (comment.replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0)
        return;

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
      var controller = this.get('controller');
      var storyIds = {};
      var newContent = [];

      controller.get('newStories').forEach(function(story) {
        if (!storyIds[parseInt(story.get('id'))]) {
          storyIds[parseInt(story.get('id'))] = true;
          newContent.unshift(story.get('content'));
        }
      });

      controller.get('content').forEach(function(story) {
        if (!storyIds[parseInt(story.get('id'))]) {
          storyIds[parseInt(story.get('id'))] = true;
          newContent.push(story);
        }
      });

      this.currentModel.setObjects(newContent);
      this.set('controller.newStories', []);
    }
  }
});
