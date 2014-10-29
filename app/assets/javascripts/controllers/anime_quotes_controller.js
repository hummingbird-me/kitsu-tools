HB.AnimeQuotesController = Ember.ObjectController.extend({

  animeQuotes: function(){
    var self = this;
    return this.store.filter('quote', function(quote){
      return (self.content == quote.anime_id);
    });
  }.property('@each.quote')
  
});
