Hummingbird.HeaderController = Ember.Controller.extend
  newNotifications: Ember.computed.filterBy("notifications", "seen", false)
  showSearchbar: false

  panelNotifications: (->
    @store.all('notification')
  ).property('@each.notification')

  init: (->
    bloodhound = new Bloodhound
      datumTokenizer: (d)->
        Bloodhound.tokenizers.whitespace(d.value)
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote:
        url: '/search.json?query=%QUERY&type=mixed'
        filter: (results)->
          Ember.$.map(results.search, (r)->
            #r.title = r.title[0..20]+"..." if r.title.length > 20
            {title: r.title, type: r.type, image: r.image, link: r.link}
          )
    bloodhound.initialize()
    @set('bhInstance', bloodhound)
    @_super()
  )

  submitSearch: (->
    @transitionToRoute('search', @get('searchTerm'));
  )
  instantSearch: (->
    blodhound = @get('bhInstance')
    searchterm = @get('searchTerm')
    @set('fullSearchLink', "/search/"+searchterm)
    blodhound.get searchterm, (suggestions) =>
      @set('instantSearchResults', suggestions)
  ).observes('searchTerm')

  actions:
    toggleSearchbar: ->
      @toggleProperty('showSearchbar')
      if @get('showSearchbar') == false
        @set('instantSearchResults', [])
      false #prevent event-bubbling