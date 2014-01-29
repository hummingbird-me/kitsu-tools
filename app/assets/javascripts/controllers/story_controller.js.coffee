Hummingbird.StoryController = Ember.ObjectController.extend
  commentStory: Ember.computed.equal('model.type', 'comment')
  mediaStory: Ember.computed.equal('model.type', 'media_story')
  followedStory: Ember.computed.equal('model.type', 'followed')
  knownStory: Ember.computed.any('commentStory', 'mediaStory', 'followedStory')
  unknownStory: Ember.computed.not('knownStory')

  mediaRoute: (->
    if @get('model.media').constructor.toString() == "Hummingbird.Anime"
      return 'anime'
  ).property('model.media')
