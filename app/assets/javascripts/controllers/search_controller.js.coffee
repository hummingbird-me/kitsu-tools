Hummingbird.SearchController = Ember.Controller.extend
  searchResults: []
  selectedFilter: null
  searchTerm: ""
  filters: ["Everything", "Anime", "User"]

  init: (->
    bloodhound = new Bloodhound
      datumTokenizer: (d)->
        Bloodhound.tokenizers.whitespace(d.value)
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote:
        url: '/search.json?query=%QUERY&type=full'
        filter: (results)->
          Ember.$.map(results.search, (r)->
            {
              type: r.type,
              title: r.title,
              desc: r.desc,
              image: r.image,
              link: r.link,
              badges: r.badges
            }
          )
    bloodhound.initialize()
    @set('bhInstance', bloodhound)
    @_super()
  )

  hasSearchTerm: (->
    @get('searchTerm').length != 0
  ).property('searchTerm')

  filteredSearchResutlts: (->
    results = @get('searchResults')
    filter  = @get('selectedFilter')
    filterd = []

    jQuery.each(results, (index, item)->
      if(item.type == filter.toLowerCase() || filter == "Everything")
        if(item.title != "")
          filterd.push(item)
    )
    filterd
  ).property('searchResults', 'selectedFilter')

  instantSearch: (->
    blodhound = @get('bhInstance')
    searchterm = @get('searchTerm')
    blodhound.get searchterm, (suggestions) =>
      suggestions.pop()
      @set('searchResults', suggestions)
  ).observes('searchTerm')
