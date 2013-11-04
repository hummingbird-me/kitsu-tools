Hummingbird.AnimeController = Ember.ObjectController.extend
  activeTab: "Genres"

  showGenres: (-> @get('activeTab') == "Genres").property('activeTab')
  showFranchise: (-> @get('activeTab') == "Franchise").property('activeTab')
  showQuotes: (-> @get('activeTab') == "Quotes").property('activeTab')
  showStudios: (-> @get('activeTab') == "Studios").property('activeTab')

  # Legacy -- remove after Ember transition is complete.
  fullQuotesURL: (-> "/anime/" + @get('model.id') + "/quotes").property('model.id')
  fullReviewsURL: (-> "/anime/" + @get('model.id') + "/reviews").property('model.id')
  # End Legacy

  actions:
    switchTo: (newTab) ->
      @set 'activeTab', newTab
      if newTab == "Franchise"
        @get 'model.franchise'
