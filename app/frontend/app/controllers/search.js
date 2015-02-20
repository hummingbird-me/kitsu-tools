import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Controller.extend({
  scopes: [
    { value: 'all', label: 'Everything' },
    { value: 'anime', label: 'Anime' },
    { value: 'manga', label: 'Manga' },
    { value: 'users', label: 'Users' },
    { value: 'groups', label: 'Groups' },
  ],
  queryParams: {
    query: { replace: true },
    scope: { }
  },
  performingSearch: false,
  performedSearch: false,
  searchResults: [],
  searchRequest: '',
  scope: 'all',
  query: '',

  observeQuery: function() {
    if (this.get('query').length > 2) {
      Ember.run.debounce(this, this.performSearch, 400);
    }
  }.observes('query'),

  observeScope: function() {
    if (this.get('query').length > 2) {
      this.performSearch();
    }
  }.observes('scope'),

  performSearch: function() {
    if (this.get('performingSearch')) {
      return Ember.run.later(this, this.performSearch, 100);
    }

    if (this.get('query').length < 3) {
      return this.setProperties({
        searchResults: [],
        searchRequest: this.get('query')+' (too short, min. 3 chars)',
        performedSearch: true,
        performingSearch: false
      });
    }

    this.set('performingSearch', true);
    ajax({
      url: '/search.json?depth=full&scope=' + this.get('scope') + '&query=' + this.get('query'),
      type: 'GET'
    }).then((payload) => {
      this.setProperties({
        searchResults: payload.search,
        searchRequest: this.get('query'),
        performedSearch: true,
        performingSearch: false
      });
    });
  },

  actions: {
    submitSearch: function(){
      this.performSearch();
    }
  }
});
