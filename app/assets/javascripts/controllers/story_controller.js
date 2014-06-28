Hummingbird.StoryController = Ember.ObjectController.extend(Hummingbird.HasCurrentUser, {
  commentStory: Ember.computed.equal('model.type', 'comment'),
  mediaStory: Ember.computed.equal('model.type', 'media_story'),
  followedStory: Ember.computed.equal('model.type', 'followed'),
  knownStory: Ember.computed.any('commentStory', 'mediaStory', 'followedStory'),
  unknownStory: Ember.computed.not('knownStory'),
  substories: Ember.computed.any('allSubstories', 'model.substories'),
  selfPost: Hummingbird.computed.propertyEqual('model.poster.id', 'model.user.id'),
  moreThanTwoSubstories: Em.computed.gt('model.substoryCount', 2),

  showAll: false,
  loadingAll: false,
  loadedAll: Hummingbird.computed.propertyEqual('substories.length', 'model.substoryCount'),

  belongsToUser: function () {
    var loggedInUser = this.get('currentUser');
    return loggedInUser.get('id') === this.get('model.poster.id') || loggedInUser.get('id') === this.get('model.user.id');
  }.property('model.poster'),

  mediaRoute: function () {
    if (this.get('model.media').constructor.toString() === "Hummingbird.Anime") {
      return 'anime';
    }
  }.property('model.media'),


  displaySubstories: function () {
    var sorted = this.get('substories').sortBy('createdAt').reverse();
    if (sorted.length > 2 && !this.get('showAll')) {
      return sorted.slice(0, 2);
    } else {
      return sorted;
    }
  }.property('substories', 'showAll'),

  actions: {
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
      substory.destroyRecord();
    }
  }
});
