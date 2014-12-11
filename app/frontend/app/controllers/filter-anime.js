import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Controller.extend({
  queryParams: ['query'],

  filterUserCount: [],
  filterStudios: [],
  filterRating: [],
  filterGenres: [],
  filterTimes: [],

  selectedSort: "rating",
  selectedItems: [],
  filterResults: [],

  page: 1,
  query: "",
  loading: false,

  encodeQuery: function(){
    var query  = "?page=" + this.get('page');
        query += "&sort=" + this.get('selectedSort');

    this.get('selectedItems').forEach(function(item){
      query += "&" + item.fkey + "[]=" + item.fval;
    });

    this.set('query', query);
    return query;
  },

  decodeQuery: function(){
    var query = this.get('query'),
        self = this,
        keymap = {
          'page': { single: true,  name: 'page' },
          'sort': { single: true,  name: 'selectedSort' },
          'g':    { single: false, name: 'filterGenres' },
          'y':    { single: false, name: 'filterTimes' }
        };

    query = query.substring(1);
    query.split('&').forEach(function(param){
      var data = param.split('='),
          ckey = keymap[data[0].replace('[]', '')];

      if (ckey !== undefined) {
        if (ckey.single) {
          self.set(ckey.name, data[1]);
        } else {
          var item = self.get(ckey.name).findBy('fval', data[1]);
          if (item === undefined) { return; }
          item.set('selected', true);
          self.get('selectedItems').pushObject(item);
        }
      }
    });
  }.observes('filterGenres'), // <- Async loaded selections

  applyFilter: function(){
    if (this.get('loading')) {
      Ember.run.later(this, this.performSearch, 100);
      return;
    }

    var query = this.encodeQuery(),
        self = this;

    if((query.match(/\&/g) || []).length < 2) { return; }
    query += "&new_filter=true";

    this.set('loading', true);
    ajax({
      url: '/anime/filter.json' + query,
      type: "GET"
    }).then(function(payload) {
      self.store.pushPayload(payload);
      self.setProperties({
        'filterResults': payload.anime,
        'loading': false
      });
    });
  }.observes('selectedItems.length', 'selectedSort'),

  actions: {
    switchPage: function(mod){
      var newPage = this.get('page') + mod;
      if(newPage < 1) { return; }
      // Add check for max page

      this.set('page', newPage);
      this.send('applyFilter');
    },

    selectItem: function(item){
      var currentState = item.get('selected');
      item.set('selected', !currentState);

      if(currentState) { this.get('selectedItems').removeObject(item); }
      else { this.get('selectedItems').pushObject(item); }
    }
  }
});
