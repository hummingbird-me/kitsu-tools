import Ember from 'ember';
import ajax from 'ic-ajax';

var REQUIRED_RATING_COUNT = 5;

export default Ember.Controller.extend({
  showManga: false,
  animeData: function(){
    if(this.get('hasSearchTerm')){
      var self = this;
      return this.store.all('anime').filter(function(anime){
        return self.get('searchResults').contains(anime.get('id'));
      });
    }
    return this.get('content.anime');
  }.property('content.anime', 'hasSearchTerm', 'searchResults'),

  mangaData: function(){
    if(this.get('hasSearchTerm')){
      var self = this;
      return this.store.all('manga').filter(function(manga){
        return self.get('searchResults').contains(manga.get('id'));
      });
    }
    return this.get('content.manga');
  }.property('content.manga', 'hasSearchTerm', 'searchResults'),

  canContinue: Ember.computed.gte('totalRatings', REQUIRED_RATING_COUNT),
  totalRatings: 0,
  remainingRatings: function(){
    return REQUIRED_RATING_COUNT - this.get('totalRatings');
  }.property('totalRatings'),

  hasSearchTerm: Ember.computed.gt('searchTerm.length', 2),
  searchTerm: "",
  searchResults: [],
  performedSearch: false,
  performSearch: function() {
    if (this.get('loading')) {
      Ember.run.later(this, this.performSearch, 100);
      return;
    }

    var self = this,
        dtpe = (this.get('showManga')) ? 'manga' : 'anime';

    if(this.get('searchTerm').length < 2){
      this.setProperties({
        'searchResults': [],
        'performedSearch': true
      });
      return;
    }

    this.set('loading', true);
    ajax({
      url: '/search.json?depth=element&scope='+dtpe+'&query=' + this.get('searchTerm'),
      type: "GET"
    }).then(function(payload) {
      self.setProperties({
        'searchResults': payload.search.map(function(x) { return x.id; }),
        'performedSearch': true,
        'loading': false
      });

      var formatted = {};
      formatted[dtpe] = payload.search;
      self.store.pushPayload(formatted);
    });
  }.observes('searchTerm'),

  updateLibraryEntry: function(media, userRating){
    var libraryEntry = media.get('libraryEntry');
    libraryEntry.set('rating', userRating);
    libraryEntry.save();
  },


  actions: {
    mangaTab: function(setTab){
      this.setProperties({
        'showManga': setTab,
        'searchTerm': "",
        'searchResutls': []
      });
    },

    pickMalFile: function() {
      Ember.$('#mal-file').click();
    },

    importMal: function(file) {
      let user = this.get('currentUser.content.content');
      user.importList('myanimelist', file).then(() => {
        Ember.run.later(() => {
          this.transitionToRoute('onboarding.finish');
        }, 1000);
      });
    },

    setLibraryRating: function(userRating, media){

      if(media.get('libraryEntry') != null){
        this.updateLibraryEntry(media, userRating);
        return;
      }

      var libraryEntry;

      // Anime and Manga library entries are using
      // different models in ember data!
      if(media.constructor.modelName === 'anime') {
        libraryEntry = this.store.createRecord('LibraryEntry', {
          anime: media,
          status: "Completed",
          isFavorite: false,
          rating: userRating,
          episodesWatched: media.get('episodeCount'),
          "private": false,
          rewatching: false,
          rewatchCount: 0,
          notes: "",
          fav_rank: 9999
        });
      } else {
        libraryEntry = this.store.createRecord('MangaLibraryEntry', {
          manga: media,
          status: "Completed",
          isFavorite: false,
          rating: userRating,
          chaptersRead: media.chapterCount,
          volumesRead: media.volumeCount,
          "private": false,
          rereading: false,
          rereadCount: 0,
          notes: ""
        });
      }

      libraryEntry.save();
      this.incrementProperty('totalRatings');
    }
  }
});
