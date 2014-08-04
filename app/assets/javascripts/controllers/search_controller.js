Hummingbird.SearchController = Ember.Controller.extend({
  queryParams: ['query', 'filter'],
  searchResults: [],
  filter: null,
  query: "",
  filters: ["Everything", "Anime", "Manga", "User"],

  init: function () {
    this.set('didSearch', false);
    this._super();
    console.log(this.get('query'));
    if(!Ember.empty(this.get('query'))){
      this.performSearch();
    }
  },

  filteredSearchResults: function(){
    var self = this;
    return this.get('searchResults').filter(function(result){
      return (result.type == self.get('filter').toLowerCase() || "Everything" == self.get('filter'));
    });
  }.property('searchResults', 'filter'),

  performSearch: function(){
    var self = this;
    ic.ajax({
      url: '/search.json?type=full&query='+this.get('query'),
      type: "GET"
    }).then(function(payload) {
      self.setProperties({
        'searchResults': payload.search,
        'didSearch': true
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
