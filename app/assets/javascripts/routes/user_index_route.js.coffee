Hummingbird.UserIndexRoute = Ember.Route.extend Hummingbird.Paginated,
  enter: ->
    @controllerFor('application').send("setupQuickUpdate")

  fetchPage: (page) ->
    @store.find 'story', user_id: @modelFor('user').get('id'), page: page

  setupController: (controller, model) ->
    controller.set 'userInfo', @store.find('userInfo', @modelFor('user').get('id'))
    Ember.$.ajax
      url: '/api/v1/users/' + @modelFor('user').get('id') + '/favorite_anime'
      type: 'GET'
      success: (payload)->
        controller.set('favorite_anime', payload)
      failure: ->
        console.log 'failed to retrieve favorite anime'
       
    # For the pagination mixin to work correctly:
    @setCanLoadMore(true)
    controller.set 'canLoadMore', true
    controller.set 'model', []

  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('username') + "'s Profile"
