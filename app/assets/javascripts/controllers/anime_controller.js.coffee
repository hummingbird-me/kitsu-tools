Hummingbird.AnimeController = Ember.ObjectController.extend
  activeTab: "Genres"

  showGenres: (-> @get('activeTab') == "Genres").property('activeTab')
  showFranchise: (-> @get('activeTab') == "Franchise").property('activeTab')

  actions:
    switchTo: (newTab) ->
      @set 'activeTab', newTab
      if newTab == "Franchise"
        @get 'model.franchise'
