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


  encodeQuery: function(){
    var query = "?page=" + this.get('showPage');

    $.each(this.get('selectTime'), function(key, val){
      if(val) query += "&y[]=" + key;
    });

    $.each(this.get('selectGenre'), function(key, val){
      if(val) query += "&g[]=" + key;
    });

    this.set('query', query);
  },

  decodeQuery: function(){

  },

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
