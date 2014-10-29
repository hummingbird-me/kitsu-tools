HB.AnimeQuotesController = Ember.ObjectController.extend(HB.HasCurrentUser, {

  showCreate: false,
  quoteText: "",
  quoteChar: "",

  animeQuotes: function(){
    var self = this;
    return this.store.filter('quote', function(quote){
      return (self.content == quote.anime_id);
    });
  }.property('@each.quote'),


  actions: {
    toggleQuoteCreate: function(){
      this.toggleProperty('showCreate');
    },

    toggleQuoteFavorite: function(quote) {
      quote.set('isFavorite', !quote.get('isFavorite'));
      return quote.save().then(Ember.K, function() {
        return quote.rollback();
      });
    },
    
    submitQuote: function(){
      var self = this,
          quote = this.store.createRecord('quote', {
            anime_id: self.content,
            characterName: self.get('quoteChar'),
            content: self.get('quoteText'),
            username: self.get('currentUser.username'),
            favoriteCount: 0,
            isFavorite: false
          });

      quote.save();
      this.set('showCreate', false);
    }
  }
  
});
