Hummingbird.ReviewsShowRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'review', params.review_id

  afterModel: (resolvedModel) ->
    Ember.run.next -> window.scrollTo 0, 0
    Hummingbird.TitleManager.setTitle @modelFor('anime').get('displayTitle') + " Review by " + resolvedModel.get('user.username')

  actions:
    upvote: ->
      if @currentModel.get('liked') == "true"
        @send "unvote"
        return
      @currentModel.set('liked', "true")
      ic.ajax
        url: "/reviews/" + @currentModel.get('id') + "/vote"
        type: "POST"
        data:
          type: "up"
      .then Ember.K, ->
        alert "Couldn't recommend review, something went wrong."

    downvote: ->
      if @currentModel.get('liked') == "false"
        @send "unvote"
        return
      @currentModel.set('liked', "false")
      ic.ajax
        url: "/reviews/" + @currentModel.get('id') + "/vote"
        type: "POST"
        data:
          type: "down"
      .then Ember.K, ->
        alert "Couldn't downvote review, something went wrong."

    unvote: ->
      @currentModel.set('liked', null)
      ic.ajax
        url: "/reviews/" + @currentModel.get('id') + "/vote"
        type: "POST"
        data:
          type: "remove"
      .then Ember.K, ->
        alert "Couldn't vote on review, something went wrong."

