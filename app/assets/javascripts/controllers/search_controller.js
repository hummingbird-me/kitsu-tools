Hummingbird.SearchController = Ember.Controller.extend({
  filters: ["Everything", "Anime", "Manga", "User"],
  queryParams: ['query', 'filter'],
  performedSearch: false,
  userTypedSearch: false,
  searchResults: [],
  searchRequest: "",
  filter: "Everything",
  query: "",

  filteredSearchResults: function(){
    var self = this;
    return this.get('searchResults').filter(function(result){
      return (result.type == self.get('filter').toLowerCase() || "Everything" == self.get('filter'));
    });
  }.property('searchResults', 'filter'),



  // Devnote: For some reason, the Ember query parameter is not accesible
  // during init or after init._super(); This hack will trigger at the first
  // query change unless the seach term is <2 chars long. (Ember beta build)
  // On the first change, queryCounter actually still is set to zero.
  timesQueryChanged: 0,

  countQueryChanged: function (){
    this.incrementProperty('timesQueryChanged')
  }.observes('query'),

  forcePerformSearch: function(){
    if(!this.get('performedSearch') && !Ember.empty(this.get('query')))
      if(this.get('query').length > 2 && this.get('timesQueryChanged') == 0)
        this.performSearch();
  }.observes('query'),



  performSearch: function(){
    if(this.get('query').length < 3){
      this.setProperties({
        'searchResults': [],
        'searchRequest': self.get('query')+' (too short)',
        'performedSearch': true
      });
      return;
    }

    var self = this;
    ic.ajax({
      url: '/search.json?type=full&query='+this.get('query'),
      type: "GET"
    }).then(function(payload) {
      self.setProperties({
        'searchResults': payload.search,
        'searchRequest': self.get('query'),
        'performedSearch': true
      });
    });
  },

  hasquery: function () {
    return this.get('query').length !== 0;
  }.property('query'),

  actions: {
    submitSearch: function(){
      this.performSearch();
    }
  }
});
