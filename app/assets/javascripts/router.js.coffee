Hummingbird.Router.reopen
  location: 'history'

Hummingbird.Router.map ()->
  @resource 'anime', path: '/anime/:id', ->
    @resource 'reviews', path: '/reviews', ->
      @route 'show', path: '/:review_id'

  @resource 'manga', path: '/manga/:id', ->
    @route 'reviews'

  @resource 'user', path: '/users/:id', ->
    @route 'library'
    @route 'reviews'
    @route 'following'
    @route 'followers'

  @route 'sign-in'
