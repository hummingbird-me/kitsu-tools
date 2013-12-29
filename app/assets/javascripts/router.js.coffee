Hummingbird.Router.reopen
  location: 'history'

Hummingbird.Router.map ()->
  @resource 'anime', path: '/anime/:id', ->
    @route 'reviews'

  @resource 'manga', path: '/manga/:id'

  @route 'sign-in'
