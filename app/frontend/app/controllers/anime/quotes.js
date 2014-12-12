import Ember from 'ember';
import HasCurrentUser from '../../mixins/has-current-user';

export default Ember.ArrayController.extend(HasCurrentUser, {
  anime: null,
  showCreate: false,
  quoteText: "",
  quoteChar: "",

  textCorrectLength: Ember.computed.gte('quoteText.length', 10),
  charCorrectLength: Ember.computed.gte('quoteChar.length', 3),
  isFormCorrect: Ember.computed.and('textCorrectLength', 'charCorrectLength'),

  animeQuotes: function(){
    var self = this;
    return this.store.filter('quote', function(quote){
      return (self.content === quote.anime_id);
    });
  }.property('@each.quote'),

  actions: {
    toggleQuoteCreate: function(){
      this.toggleProperty('showCreate');
    },

    submitQuote: function(){
      if (!(this.get('isFormCorrect'))) { return; }

      var self = this,
          quote = this.store.createRecord('quote', {
            anime_id: self.get('content'),
            characterName: self.get('quoteChar'),
            content: self.get('quoteText'),
            username: self.get('currentUser.username'),
            favoriteCount: 0,
            isFavorite: false
          });

      quote.save();
      this.setProperties({
        'showCreate': false,
        'quoteText': "",
        'quoteChar': ""
      });
    }
  }
});
