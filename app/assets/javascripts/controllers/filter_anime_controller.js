HB.FilterAnimeController = Ember.Controller.extend({
  queryParams: ['query'],

  animeList: [],
  hasManuallySet: false,


  page: 1,
  query: "",
  loading: false,

  selectedSort: "rating",
  selectedItems: [],


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
    var query = this.get('query');

  },

  applyFilter: function(){
    if (this.get('loading')) {
      Ember.run.later(this, this.performSearch, 100);
      return;
    }

    var query = this.encodeQuery(),
        self = this;

    this.set('loading', true);
    ic.ajax({
      url: '/anime/filter.json' + query,
      type: "GET"
    }).then(function(payload) {
      self.store.pushPayload(payload);
      self.setProperties({
        'animeList': payload.anime,
        'loading': false
      });
    });
  }.observes('selectedItems.length'),


  actions: {
    switchPage: function(mod){
      var newPage = this.get('page') + mod;
      if(newPage < 1) return; 
      // Add check for max page

      this.set('page', newPage);
      this.send('applyFilter');
    },

    selectItem: function(item){
      var currentState = item.get('selected');
      item.set('selected', !currentState);

      if(currentState) this.get('selectedItems').removeObject(item);
      else this.get('selectedItems').pushObject(item);
    }
  }
});
