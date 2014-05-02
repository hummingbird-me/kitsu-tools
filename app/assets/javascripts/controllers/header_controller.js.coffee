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
            {title: r.title, type: r.type, image: r.image}
          )
    bloodhound.initialize()
    @set('bhInstance', bloodhound)
    @_super()
  )

  instantSearch: (->
    blodhound = @get('bhInstance')
    searchterm = @get('searchTerm')
    blodhound.get searchterm, (suggestions) =>
      @set('instantSearchResults', suggestions)
      jQuery.each suggestions, (index, item) ->
        console.log(item)
  ).observes('searchTerm')

  actions:
    toggleSearchbar: ->
      @toggleProperty('showSearchbar')
      if @get('showSearchbar') == false
        @set('instantSearchResults', [])
      false #prevent event-bubbling