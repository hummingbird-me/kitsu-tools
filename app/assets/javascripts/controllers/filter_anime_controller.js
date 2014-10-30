HB.FilterAnimeController = Ember.ObjectController.extend({
  queryParams: ['query'],

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
