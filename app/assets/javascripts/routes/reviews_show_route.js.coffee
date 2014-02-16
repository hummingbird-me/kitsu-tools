Hummingbird.ReviewsShowRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'review', params.review_id

  afterModel: (resolvedModel) ->
    Ember.run.next -> window.scrollTo 0, 0
    Hummingbird.TitleManager.setTitle @modelFor('anime').get('displayTitle') + " Review by " + resolvedModel.get('user.username')

  actions:
    upvote: ->
      @currentModel.set('liked', true)
      ic.ajax
        url: "/reviews/" + @currentModel.get('id') + "/vote"
        type: "POST"
        data:
          type: "up"
      .then Ember.K, ->
        alert "Couldn't recommend review, something went wrong."

    downvote: ->
      @currentModel.set('liked', false)
      ic.ajax
        url: "/reviews/" + @currentModel.get('id') + "/vote"
        type: "POST"
        data:
          type: "down"
      .then Ember.K, ->
        alert "Couldn't downvote review, something went wrong."
