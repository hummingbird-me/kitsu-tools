Hummingbird.Router.reopen
  location: 'history'

Hummingbird.Router.map ()->
  @resource 'anime', path: '/anime/:id', ->
    @route 'reviews'

  @resource 'manga', path: '/manga/:id', ->
    @route 'reviews'

  @resource 'user', path: '/users/:id', ->
    @route 'library'
    @route 'reviews'
    @route 'following'
    @route 'followers'

  @route 'sign-in'
