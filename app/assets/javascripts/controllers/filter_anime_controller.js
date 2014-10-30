HB.FilterAnimeController = Ember.ObjectController.extend({
  queryParams: ['query'],

  filterSorts: [
    {name: "Highest Rated", value: "rating"},
    {name: "Most Popular", value: "popular"},
    {name: "Newest", value: "newest"},
    {name: "Oldest", value: "oldest"}
  ],

  filterTimes: [
    "Upcoming",
    "2010s",
    "2000s",
    "1990s",
    "1980s",
    "1970s",
    "Older"
  ],

  filterGenres: function(){
    return this.store.all('genre');
  }.property('@each.genres'),
  
  query: "",
  showPage: 1,
  isLoading: false,
  animeList: [],
  selectSort: "rating",
  selectTime: {},
  selectGenre: {},
  hasManuallySet: false,


  encodeQuery: function(){
    var query  = "?page=" + this.get('showPage');
        query += "&sort=" + this.get('selectSort');

    $.each(this.get('selectTime'), function(key, val){
      if(val) query += "&y[]=" + key;
    });

    $.each(this.get('selectGenre'), function(key, val){
      if(val) query += "&g[]=" + key;
    });

    this.setProperties({
      'query': query,
      'hasManuallySet': true
    });
  },

  decodeQuery: function(){
    if(!this.get('hasManuallySet')){
      var query = this.get('query'),
          findg = query.match(/\&g\[\]\=([ A-z]+)/g);
          findy = query.match(/\&y\[\]\=([0-9A-z]+)/g);
          tempg = {},
          tempy = {};

      if(findg && findg.length > 0){
        $.each(findg, function(key, val){
          var form = val.substring(5, val.length);
          tempg[form] = true;
        });
      }

      if(findy && findy.length > 0){
        $.each(findy, function(key, val){
          var form = val.substring(5, val.length);
          tempy[form] = true;
        });
      }

      this.setProperties({
        'showPage': parseInt(/\?page\=([0-9]{1,4})/.exec(query)[1]),
        'selectSort': /\&sort\=([a-z]{6,7})/.exec(query)[1],
        'selectGenre': tempg,
        'selectTime': tempy
      });
    }
  }.observes('query'),

  updateItem: function(item, state){
    if(state) $('#'+item).addClass('active');
    else  $('#'+item).removeClass('active');
  },

  actions: {
    switchPage: function(mod){
      var newPage = this.get('showPage') + mod;
      if(newPage < 1) return; 
      // Add check for max page

      console.log(this.get('selectSort'));
      this.set('showPage', newPage);
      this.send('applyFilter');
    },

    toggleFilterTime: function(item){
      this.set('selectTime.'+item, !this.get('selectTime.'+item));
      this.updateItem(item, this.get('selectTime.'+item));
    },

    toggleFilterGenre: function(item){
      this.set('selectGenre.'+item, !this.get('selectGenre.'+item));
      this.updateItem(item, this.get('selectGenre.'+item));
    },

    applyFilter: function(){
      this.encodeQuery();

      var self = this,
          requrl = decodeURIComponent(this.get('query'));
          requrl = requrl.replace(/\[/,'%5B');
          requrl = requrl.replace(/\]/,'%5D');
          requrl += "&new_filter=true" // TEMPORARY!!
          // ^ Hacky solution to allow us to store
          //   query as an ember query param

      this.set('isLoading', true);
      $.getJSON('/anime/filter.json' + requrl, function(payload){
        self.set('isLoading', false);
        self.store.pushPayload(payload);
        self.set('animeList', payload.anime);
      });
    }
  }
});
