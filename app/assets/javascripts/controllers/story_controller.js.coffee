Hummingbird.StoryController = Ember.ObjectController.extend
  commentStory: Ember.computed.equal('model.type', 'comment')
  mediaStory: Ember.computed.equal('model.type', 'media_story')
  followedStory: Ember.computed.equal('model.type', 'followed')
  knownStory: Ember.computed.any('commentStory', 'mediaStory', 'followedStory')
  unknownStory: Ember.computed.not('knownStory')
  needs: ['user_index']
  
  belongsToUser:(->
    loggedInUser = @get('currentUser')
    return loggedInUser.get('id') == @get('model.poster.id') || loggedInUser.get('id') == @get('model.user.id')
  ).property('model.poster')

  selfpost: (->
    return (@get('model.poster.id') == @get('model.user.id'))   
  ).property('model.poster', 'model.user')
  
  mediaRoute: (->
    if @get('model.media').constructor.toString() == "Hummingbird.Anime"
      return 'anime'
  ).property('model.media')

  showAll: false

  moreThanTwoSubstories: (->
    @get('model.substories.length') > 2
  ).property('model.substories')

  moreThanFourFollows: (->
    @get('model.followedUsers.length') > 4
  ).property('model.followedUsers')

  followsCount: (->
   sorted = @get('model.followedUsers').sortBy('createdAt').reverse()
  ).property('model.substories', 'showAll')

  followedUsers: (->
    sorted = @get('model.followedUsers').sortBy('createdAt').reverse()
    if sorted.length > 4 and not @get('showAll')
      sorted.slice(0, 4)
    else
      sorted
  ).property('model.substories', 'showAll')

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
        success: (results) ->
          if results 
            userIndexCon.get('target').send('reloadFirstPage')
        failure: ->
          alert "Could not delete post"
