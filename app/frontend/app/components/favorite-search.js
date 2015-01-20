import Ember from 'ember';
/* global Bloodhound */

export default Ember.Component.extend({
  query: "",
  searchResults: [],

  bloodhound: function() {
    var bloodhound = new Bloodhound({
      datumTokenizer: function(d) {
        return Bloodhound.tokenizers.whitespace(d.value);
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 10,
      remote: {
        url: '/search.json?query=%QUERY&type=mixed',
        filter: function(results) {
          return Ember.$.map(results.search, function (r) {
            // There actually has to be a way to send the img params to the thumb generator in the request, this is just a temp. solution
            if (r.type === "user") {
              r.image = r.image.replace(/(\.[a-zA-Z]+)?\?/, ".jpg?");
            }
            return {
              title: r.title,
              type: r.type,
              image: r.image.replace((r.type==="user"?"{size}":"large"), (r.type==="user"?"small":"medium")),
              slug: r.slug
            };
          });
        }
      }
    });
    bloodhound.initialize();
    return bloodhound;
  }.property(),

  filteredSearchResults: function() {
    var self = this;
    return this.get('searchResults').filter(function(item){
      var favs = self.get('favorites').map(function(x){
        return x.get('item.id');
      });

      var isInFavs = favs.contains(item.slug);
      var isTypeOk = ( item.type === self.get('type') );
      
      return ( !isInFavs && isTypeOk ); 
    });
  }.property('searchResults.@each'),

  updateSearchResults: function() {
    var self = this;
    if (this.get('query').length > 2) {
      this.get('bloodhound').get(this.get('query'), function(results) {
        self.set('searchResults', results);
      });
    }
  },

  queryObserver: function() {
    Ember.run.debounce(this, this.updateSearchResults, 300);
  }.observes('query'),

  actions: {
    addMediaToFavorites: function(media){
      var cuser = this.get('currentUser'),
          store = this.get('targetObject.targetObject.store'),
          self = this;

      var newFav = store.createRecord('favorite', {
        'favRank': 9999
      });

      store.find('user', cuser.get('id')).then(function(user){
        newFav.set('user', user);

        store.find(media.type, media.slug).then(function(item){
          newFav.set('item', item);
          newFav.save();
          self.sendAction('action', newFav);
        });
      });
    }
  }
});
