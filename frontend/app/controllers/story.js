import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';
import propertyEqual from '../utils/computed/property-equal';
/* global Messenger */

export default Ember.ObjectController.extend(HasCurrentUser, {
  commentStory: Ember.computed.equal('model.type', 'comment'),
  mediaStory: Ember.computed.equal('model.type', 'media_story'),
  followedStory: Ember.computed.equal('model.type', 'followed'),
  knownStory: Ember.computed.any('commentStory', 'mediaStory', 'followedStory'),
  unknownStory: Ember.computed.not('knownStory'),
  substories: Ember.computed.any('allSubstories', 'model.substories'),
  selfPost: propertyEqual('model.poster.id', 'model.user.id'),
  moreThanTwoSubstories: Ember.computed.gt('model.substoryCount', 2),
  isExpanded: false,
  overflowing: false,
  showMoreText: 'Show More',

  collapsed: Ember.computed.equal('model.adult', true),
  showAll: false,
  loadingAll: false,
  loadedAll: propertyEqual('substories.length', 'model.substoryCount'),

  // Determine if we are on a group page
  isOnGroupPage: function() {
    return window.location.href.indexOf('/groups/') !== -1;
  }.property(),

  extraLikers: function() {
    return this.get('totalVotes') - this.get('recentLikers.length');
  }.property('totalVotes', 'recentLikers.length'),
  showExtraLikers: Ember.computed.gt('extraLikers', 0),

  mediaRoute: function() {
    return this.get('model.media').constructor.typeKey;
  }.property('model.media'),

  displaySubstories: function () {
    var sorted = this.get('substories').sortBy('createdAt').reverse();
    if (sorted.length > 2 && !this.get('showAll')) {
      return sorted.slice(0, 2);
    } else {
      return sorted;
    }
  }.property('substories.@each', 'showAll'),

  reversedDisplaySubstories: function() {
    return this.get('displaySubstories').reverse();
  }.property('displaySubstories.@each'),

  actions: {
    submitReply: function() {
      if (this.get('reply').replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0) {
        return;
      }

      var self = this;
      this.store.find('user', this.get('currentUser.id')).then(function(user) {
        var reply = self.store.createRecord('substory', {
          storyId: self.get('model.id'),
          user: user,
          type: "reply",
          reply: self.get('reply'),
          createdAt: new Date()
        });
        reply.save();
        self.incrementProperty('substoryCount');
        self.get('substories').addObject(reply);
        self.set('reply', '');
      });
    },

    toggleShowAll: function () {
      var self = this;
      if (!this.get('loadedAll')) {
        if (!this.get('loadingAll')) {
          // Load all substories for this story.
          this.store.find('substory', {story_id: this.get('model.id')}).then(function(substories) {
            self.set('allSubstories', substories);
            self.set('loadingAll', false);
          });
        }
        this.set('loadingAll', true);
      }
      return this.set('showAll', !this.get('showAll'));
    },

    deleteStory: function() {
      this.get('model').destroyRecord();
    },

    deleteSubstory: function(substory) {
      substory.destroyRecord().then(() => {
        this.get('substories').removeObject(substory);
        this.decrementProperty('substoryCount');
      });
    },

    toggleFullPost: function() {
      this.set('isExpanded', !this.get('isExpanded'));
      if (this.get('isExpanded')) { this.set('showMoreText', 'Show Less'); }
      else { this.set('showMoreText', 'Show More'); }
    },

    showCollapsedPost: function() {
      this.set('collapsed', false);
    },

    toggleLike: function() {
      if (!this.get('currentUser.isSignedIn')) {
        return this.transitionTo('sign-up');
      }

      this.toggleProperty('isLiked');
      Messenger().expectPromise(() => this.get('content').save(), {
        progressMessage: () => {
          if (this.get('isLiked')) {
            return "Liking post...";
          } else {
            return "Unliking post...";
          }
        },
        successMessage: () => {
          if (this.get('isLiked')) {
            return "Liked!";
          } else {
            return "Unliked.";
          }
        },
        errorMessage: "Something went wrong."
      });
    },

    toggleNSFW: function() {
      this.get('model').toggleProperty('adult');
      this.get('model').save();
    }
  }
});
