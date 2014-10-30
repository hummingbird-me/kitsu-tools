HB.FilterAnimeController = Ember.ObjectController.extend({
  
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
  selectTime: {},
  selectGenre: {},

  istrue: true,

  encodeQuery: function(){
    var query = "";

    $.each(this.get('selectTime'), function(key, val){
      if(val) query += key+",";
    });

    query = query.substring(0, query.length -1) + ";";
    $.each(this.get('selectGenre'), function(key, val){
      if(val) query += key+",";
    });

    this.set('query', query.substring(0, query.length -1));
    console.log(query);
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
    }
  }
});
