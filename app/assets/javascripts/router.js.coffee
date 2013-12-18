Hummingbird.Router.reopen
  location: 'history'

Hummingbird.Router.map ()->
  @resource 'anime', path: '/anime/:id'
  @resource 'manga', path: '/manga/:id'

  @route 'sign-in'
