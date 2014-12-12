import Ember from 'ember';
import Paginated from '../mixins/paginated';
import setTitle from '../utils/set-title';
/* global MessageBus */

export default Ember.Route.extend(Paginated, {
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
    controller.set('userInfo', this.store.find('userInfo', this.get('currentUser.id')));
    setTitle("Dashboard");
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
      if (comment.replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0) {
        return;
      }

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
      var content = this.get('controller.content'),
          newStories = this.get('controller.newStories').uniq().reverseObjects();

      content.removeObjects(newStories);
      content.unshiftObjects(newStories);

      this.set('controller.newStories', []);
    }
  }
});
