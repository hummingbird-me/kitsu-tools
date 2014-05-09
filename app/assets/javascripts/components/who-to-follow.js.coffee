Hummingbird.WhoToFollowComponent = Em.Component.extend
  actions: 
    toggleFollow: (user)->
      unless @get('currentUser.isSignedIn')
        alert "Need to be signed in!"
        return
      originalState = user.get('isFollowed')
      user.set 'isFollowed', !originalState
      ic.ajax
        url: "/users/" + user.get('id') + "/follow"
        type: "POST"
        dataType: "json"
      .then Ember.K, ->
        alert "Something went wrong."
        user.set 'isFollowed', originalState
    dismiss: (user)->
      @sendAction("action", user)
