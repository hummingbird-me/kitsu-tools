Hummingbird.MangaIndexController = Ember.ObjectController.extend
  activeTab: "Genres"

  showGenres: Ember.computed.equal('activeTab', 'Genres')

  actions:
    switchTo: (newTab) ->
      @set 'activeTab', newTab
