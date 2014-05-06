Hummingbird.HeaderController = Ember.Controller.extend
  unreadNotifications: 0
  hasUnreadNotifications: (->
    @get('unreadNotifications') != 0
  ).property('unreadNotifications')
  showSearchbar: false
  limitedNotifications: []
  entriesLoaded: (->
    return @get('recentLibraryEntries')
  ).property('recentLibraryEntries.@each')

  firstEntry: (->
    if @get('recentLibraryEntries')
      return (@get('recentLibraryEntries.firstObject.id'))
    else 
      return false
  ).property('recentLibraryEntries.@each')

  init: (->
    bloodhound = new Bloodhound
      datumTokenizer: (d)->
        Bloodhound.tokenizers.whitespace(d.value)
      queryTokenizer: Bloodhound.tokenizers.whitespace
      limit: 6
      remote:
        url: '/search.json?query=%QUERY&type=mixed'
        filter: (results)->
          Ember.$.map(results.search, (r)->
            # There actually has to be a way to send the img params to the thumb generator in the request, this is just a temp. solution
            {title: r.title, type: r.type, image: r.image.replace("{size}", "small").replace(".gif?", ".jpg?"), link: r.link}
          )
    bloodhound.initialize()
    @set('bhInstance', bloodhound)

    @store.find('notification').then( (result) =>
      newOnes = 0
      for notif in result.get('content')
        newOnes++ if notif.get('seen') == false
      @set('unreadNotifications', newOnes)
      @set('limitedNotifications', result.slice(0, 3))
    )

    @_super()
  )

  instantSearchResults: []
  hasInstantSearchResults: (->
    @get('instantSearchResults').length != 0 && @get('searchTerm').length != 0
  ).property('instantSearchResults')
  instantSearch: (->
    blodhound = @get('bhInstance')
    searchterm = @get('searchTerm')
    blodhound.get searchterm, (suggestions) =>
      @set('instantSearchResults', suggestions)
  ).observes('searchTerm')

  showUpdater: false 
  recentLibraryEntries: []

  actions:
    toggleSearchbar: ->
      @toggleProperty('showSearchbar')
      if @get('showSearchbar') == false
        @set('instantSearchResults', [])
      false #prevent event-bubbling
    submitSearch: ->
      window.location.replace("http://hummingbird.me/search?query="+@get('searchTerm'))
    toggleUpdater: ->
      self = @
      # refreshes the list for the quick update
      @toggleProperty('showUpdater')
      if @get('showUpdater') == false
        Ember.run.later @, (->
         self.send('setupQuickUpdate')
        ), 10
      false
