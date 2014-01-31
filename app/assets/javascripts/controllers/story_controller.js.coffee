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

  showAll: false

  moreThanTwoSubstories: (->
    @get('model.substories.length') > 2
  ).property('model.substories')

  displaySubstories: (->
    sorted = @get('model.substories').sortBy('createdAt').reverse()
    if sorted.length > 2 and not @get('showAll')
      sorted.slice(0, 2)
    else
      sorted
  ).property('model.substories', 'showAll')

  actions:
    toggleShowAll: ->
      @set 'showAll', not @get('showAll')
