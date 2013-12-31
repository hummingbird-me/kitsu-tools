Hummingbird.AnimeIndexController = Ember.ObjectController.extend
  activeTab: "Genres"
  language: null

  showGenres: Ember.computed.equal('activeTab', 'Genres')
  showFranchise: Ember.computed.equal('activeTab', 'Franchise')
  showQuotes: Ember.computed.equal('activeTab', 'Quotes')
  showStudios: Ember.computed.equal('activeTab', 'Studios')
  showCast: Ember.computed.equal('activeTab', 'Cast')

  fbLikeURL: (->
    "http://hummingbird.me/anime/" + @get('model.id')
  ).property('model.id')

  filteredCast: (->
    @get('model.featuredCastings').filterBy 'language', @get('language')
  ).property('model.featuredCastings', 'language')

  # Legacy -- remove after Ember transition is complete.
  fullQuotesURL: (-> "/anime/" + @get('model.id') + "/quotes").property('model.id')
  fullReviewsURL: (-> "/anime/" + @get('model.id') + "/reviews").property('model.id')
  # End Legacy

  actions:
    switchTo: (newTab) ->
      @set 'activeTab', newTab
      if newTab == "Franchise"
        @get 'model.franchise'

    setLanguage: (language) ->
      @set 'language', language
      @send 'switchTo', 'Cast'

