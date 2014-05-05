Hummingbird.HeaderController = Ember.Controller.extend
  unreadNotifications: 0
  hasUnreadNotifications: (->
    @get('unreadNotifications') != 0
  ).property('unreadNotifications')
  showSearchbar: false
  limitedNotifications: []


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
            {title: r.title, type: r.type, image: r.image, link: r.link}
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
    @get('instantSearchResults').length != 0
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
      alert 'a'
      @transitionToRoute('search', @get('searchTerm'));
    toggleUpdater: ->
      self = @
      # refreshes the list for the quick update
      @toggleProperty('showUpdater')
      if @get('showUpdater') == false
        Ember.run.later @, (->
         self.send('setupQuickUpdate')
        ), 300
      false
