HB.FilterAnimeController = Ember.Controller.extend({
  queryParams: ['query'],

  query: "",
  showPage: 1,
  isLoading: false,
  animeList: [],
  selectTime: {},
  selectGenre: {},
  hasManuallySet: false,

  selectedSort: "rating",
  selectedItems: [],


  encodeQuery: function(){
    var query  = "?page=" + this.get('showPage');
        query += "&sort=" + this.get('selectedSort');

    this.get('selectedItems').forEach(function(item){
      query += "&" + item.fkey + "[]=" + item.fval;
    });

    this.set('query', query);
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
        'selectedSort': /\&sort\=([a-z]{6,7})/.exec(query)[1],
        'selectGenre': tempg,
        'selectTime': tempy
      });
    }
  }.observes('query'),

  applyFilter: function(){
    this.encodeQuery();

    console.log(this.get('query'));
    /*

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
    */
  }.observes('selectedItems.length'),


  actions: {
    switchPage: function(mod){
      var newPage = this.get('showPage') + mod;
      if(newPage < 1) return; 
      // Add check for max page

      this.set('showPage', newPage);
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
