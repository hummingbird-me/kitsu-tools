import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Controller.extend({
  filters: ["Everything", "Anime", "Manga", "User"],
  queryParams: ['query', 'filter'],
  performingSearch: false,
  performedSearch: false,
  userTypedSearch: false,
  searchResults: [],
  searchRequest: "",
  filter: "Everything",
  query: "",

  filteredSearchResults: function(){
    var self = this;
    return this.get('searchResults').filter(function(result){
      return (result.type === self.get('filter').toLowerCase() || "Everything" === self.get('filter'));
    });
  }.property('searchResults', 'filter'),

  observeQuery: function() {
    if (this.get('query.length') >= 2) {
      Ember.run.debounce(this, this.performSearch, 500);
    }
  }.observes('query'),

  performSearch: function() {
    if (this.get('performingSearch')) {
      Ember.run.later(this, this.performSearch, 100);
      return;
    }

    var self = this;

    if(this.get('query').length < 2){
      this.setProperties({
        'searchResults': [],
        'searchRequest': self.get('query')+' (too short, min. 2 chars)',
        'performedSearch': true
      });
      return;
    }

    this.set('performingSearch', true);
    ajax({
      url: '/search.json?type=full&query=' + this.get('query'),
      type: "GET"
    }).then(function(payload) {
      self.set('performingSearch', false);
      var query = self.get('query');
      self.setProperties({
        'searchResults': payload.search,
        'searchRequest': query,
        'performedSearch': true
      });
    });
  },

  actions: {
    submitSearch: function(){
      this.performSearch();
    }
  }
});
