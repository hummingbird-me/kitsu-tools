import Ember from 'ember';
import Paginated from '../mixins/paginated';
import setTitle from '../utils/set-title';
/* global MessageBus */
/* global moment */

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
    controller.setProperties({
      'userInfo': this.store.find('userInfo', this.get('currentUser.id')),
      'trendingGroups': this.store.find('group', { trending: true, limit: 3 }),
      'breakCounter': moment.unix(parseInt(window.genericPreload.break_counter)).fromNow().replace('ago', '')
    });
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

    postComment: function(post) {
      if (post.comment.replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0) {
        return;
      }

      var story = this.store.createRecord('story', {
        type: 'comment',
        poster: this.get('currentUser.content.content'),
        user: this.get('currentUser.content.content'),
        comment: post.comment,
        adult: post.isAdult
      });
      this.currentModel.unshiftObject(story);
      story.save();
    },

    showNewStories: function() {
      // newStories is an array of Promises so grab the content
      var newStories = this.get('controller.newStories').mapBy('content').reverseObjects(),
          content = this.get('controller.content'),
          contentIds = content.mapBy('id');


      // remove duplicate objects from newStories rather than content.
      var objectsToRemove = [];
      newStories.mapBy('id').forEach(function(id, index) {
        if (contentIds.contains(id)) {
          objectsToRemove.push(newStories.objectAt(index));
        }
      });
      newStories.removeObjects(objectsToRemove);
      content.unshiftObjects(newStories);

      this.set('controller.newStories', []);
    }
  }
});
