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

  showAll: false,
  loadingAll: false,
  loadedAll: propertyEqual('substories.length', 'model.substoryCount'),

  extraLikers: function() {
    return this.get('totalVotes') - this.get('recentLikers.length');
  }.property('totalVotes', 'recentLikers.length'),
  showExtraLikers: Ember.computed.gt('extraLikers', 0),

  belongsToUser: function() {
    var currentUserId = this.get('currentUser.id');
    return currentUserId === this.get('model.poster.id') || currentUserId === this.get('model.user.id');
  }.property('model.poster.id', 'model.user.id'),

  canDeleteStory: function() {
    return (!this.get('isNew')) && (this.get('belongsToUser') || this.get('currentUser.isAdmin'));
  }.property('isNew', 'belongsToUser', 'currentUser.isAdmin'),

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
          story: self.get('model'),
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
      var self = this;
      substory.destroyRecord().then(function() {
        self.get('model.substories').removeObject(substory);
        self.decrementProperty('substoryCount');
      });
    },

    toggleFullPost: function() {
      this.set('isExpanded', !this.get('isExpanded'));
      if (this.get('isExpanded')) { this.set('showMoreText', 'Show Less'); }
      else { this.set('showMoreText', 'Show More'); }
    },

    toggleLike: function() {
      var self = this;
      this.toggleProperty('isLiked');

      Messenger().expectPromise(function() {
        return self.get('content').save();
      }, {
        progressMessage: function() {
          if (self.get('isLiked')) {
            return "Liking post...";
          } else {
            return "Unliking post...";
          }
        },
        successMessage: function() {
          if (self.get('isLiked')) {
            return "Liked!";
          } else {
            return "Unliked.";
          }
        },
        errorMessage: "Something went wrong."
      });
    }
  }
});
