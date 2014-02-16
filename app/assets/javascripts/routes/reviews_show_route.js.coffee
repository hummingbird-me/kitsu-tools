Hummingbird.ReviewsShowRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'review', params.review_id

  afterModel: (resolvedModel) ->
    Ember.run.next -> window.scrollTo 0, 0
    Hummingbird.TitleManager.setTitle @modelFor('anime').get('displayTitle') + " Review by " + resolvedModel.get('user.username')
