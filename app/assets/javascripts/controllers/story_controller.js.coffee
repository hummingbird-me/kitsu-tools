Hummingbird.StoryController = Ember.ObjectController.extend
  commentStory: Ember.computed.equal('model.type', 'comment')
  mediaStory: Ember.computed.equal('model.type', 'media_story')
  followedStory: Ember.computed.equal('model.type', 'followed')
  knownStory: Ember.computed.any('commentStory', 'mediaStory', 'followedStory')
  unknownStory: Ember.computed.not('knownStory')
  needs: ['current_user', 'user_index']
  
  belongsToUser:(->
    window.loggedInUser = @get('controllers.current_user.model')
    console.log( @get 'model.poster' )
    return loggedInUser.get('id') == @get('model.poster.id')
  ).property('model.poster')
  
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
    removeComment: ->
      feeduser = @get('user.id')
      _id = @get('model.id')
      story = @get('model')
      userIndexCon = @get('controllers.user_index')      
      Ember.$.ajax
        url: '/api/v1/users/' + feeduser + '/feed/remove'
        method: 'POST'
        data: {story_id: _id}
        success: ->
          stories = userIndexCon.store.find 'story', user_id: userIndexCon.get('userInfo.id')
          userIndexCon.set('content', stories)
        failure: ->
          alert "Could not delete post"
