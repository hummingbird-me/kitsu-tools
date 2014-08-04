Hummingbird.SearchController = Ember.Controller.extend({
  queryParams: ['query', 'filter'],
  searchResults: [],
  filter: null,
  query: "",
  filters: ["Everything", "Anime", "Manga", "User"],

  init: function () {
    if(!Ember.empty(this.get('query'))){
      this.performSearch;
    }
    this._super();
  },

  filteredSearchResults: function(){
    return this.get('searchResults');
  }.property('searchResults'),

  performSearch: function(){
    var self = this;
    ic.ajax({
      url: '/search.json?type=full&query='+this.get('query'),
      type: "GET"
    }).then(function(payload) {
      self.set('searchResults', payload.search);
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
