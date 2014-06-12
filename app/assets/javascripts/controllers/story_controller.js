Hummingbird.StoryController = Ember.ObjectController.extend({
  commentStory: Ember.computed.equal('model.type', 'comment'),
  mediaStory: Ember.computed.equal('model.type', 'media_story'),
  followedStory: Ember.computed.equal('model.type', 'followed'),
  knownStory: Ember.computed.any('commentStory', 'mediaStory', 'followedStory'),
  unknownStory: Ember.computed.not('knownStory'),
  needs: ['user_index'],

  belongsToUser: function () {
    var loggedInUser;
    loggedInUser = this.get('currentUser');
    return loggedInUser.get('id') === this.get('model.poster.id') || loggedInUser.get('id') === this.get('model.user.id');
  }.property('model.poster'),

  selfPost: function () {
    return this.get('model.poster.id') === this.get('model.user.id');
  }.property('model.poster.id', 'model.user.id'),

  mediaRoute: function () {
    if (this.get('model.media').constructor.toString() === "Hummingbird.Anime") {
      return 'anime';
    }
  }.property('model.media'),

  showAll: false,

  moreThanTwoSubstories: function () {
    return this.get('model.substories.length') > 2;
  }.property('model.substories'),

  moreThanFourFollows: function () {
    return this.get('model.followedUsers.length') > 4;
  }.property('model.followedUsers'),

  followsCount: function () {
    // TL Note: this is ... interesting
    var sorted;
    return sorted = this.get('model.followedUsers').sortBy('createdAt').reverse();
  }.property('model.substories', 'showAll'),

  followedUsers: function () {
    var sorted = this.get('model.followedUsers').sortBy('createdAt').reverse();
    if (sorted.length > 4 && !this.get('showAll')) {
      return sorted.slice(0, 4);
    } else {
      return sorted;
    }
  }.property('model.substories', 'showAll'),

  displaySubstories: function () {
    var sorted = this.get('model.substories').sortBy('createdAt').reverse();
    if (sorted.length > 2 && !this.get('showAll')) {
      return sorted.slice(0, 2);
    } else {
      return sorted;
    }
  }.property('model.substories', 'showAll'),

  actions: {
    toggleShowAll: function () {
      return this.set('showAll', !this.get('showAll'));
    },
    removeComment: function () {
      var feeduser, story, userIndexCon, _id;
      feeduser = this.get('user.id');
      _id = this.get('model.id');
      story = this.get('model');
      userIndexCon = this.get('controllers.user_index');
      return Ember.$.ajax({
        url: '/api/v1/users/' + feeduser + '/feed/remove',
        method: 'POST',
        data: {
          story_id: _id
        },
        success: function (results) {
          if (results) {
            return userIndexCon.get('target').send('reloadFirstPage');
          }
        },
        error: function () {
          return alert("Could not delete post");
        }
      });
    }
  }
});
