Hummingbird.UserRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'user', params.id

  actions:
    toggleFollow: ->
      that = this
      ic.ajax
        url: "/users/" + @currentModel.get('id') + "/follow"
        type: "POST"
        dataType: "json"
      .then ->
        that.currentModel.set 'isFollowed', !that.currentModel.get('isFollowed')
      , ->
        alert "Something went wrong."
