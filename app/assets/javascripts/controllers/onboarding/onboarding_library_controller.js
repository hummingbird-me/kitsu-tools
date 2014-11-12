var REQUIRED_RATING_COUNT = 5;


HB.OnboardingLibraryController = Ember.Controller.extend(HB.HasCurrentUser, {

  showManga: false,
  animeData: function(){
    if(this.get('hasSearchTerm')) return this.get('searchResults');
    return this.get('content.anime');
  }.property('content.anime', 'hasSearchTerm', 'searchResults'),

  mangaData: function(){
    if(this.get('hasSearchTerm')) return this.get('searchResults');
    return this.get('content.manga');
  }.property('content.manga', 'hasSearchTerm', 'searchResults'),

  canContinue: Em.computed.gte('totalRatings', REQUIRED_RATING_COUNT),
  totalRatings: 0,
  remainingRatings: function(){
    return REQUIRED_RATING_COUNT - this.get('totalRatings');
  }.property('totalRatings'),

  hasSearchTerm: Em.computed.gt('searchTerm.length', 2),
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
    ic.ajax({
      url: '/search.json?type=element&datatype='+dtpe+'&query=' + this.get('searchTerm'),
      type: "GET"
    }).then(function(payload) {
      self.setProperties({
        'searchResults': payload.search,
        'performedSearch': true,
        'loading': false
      });

      var formatted = {}
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

    setLibraryRating: function(userRating, media){

      if(media.get('libraryEntry') != null){
        this.updateLibraryEntry(media, userRating);
        return;
      }

      // Anime and Manga library entries are using
      // different models in ember data!
      if(media.constructor.typeKey == 'anime') {
        var libraryEntry = this.store.createRecord('LibraryEntry', {
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
        var libraryEntry = this.store.createRecord('MangaLibraryEntry', {
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
