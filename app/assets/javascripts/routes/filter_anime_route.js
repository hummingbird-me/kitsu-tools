HB.FilterAnimeRoute = Ember.Route.extend({

  setupController: function(controller){

    // Every object will be mapped to contain a value for fkey (the query key)
    // and fval (the query value). These values will be sent to the server to
    // request the respective search results.

    this.store.find('genre').then(function(genres){
      controller.set('filterGenres', genres.map(function(genre) {
        return Ember.Object.create({
          model: genre,
          selected: false,
          fkey: "g",
          fval: genre.get('id')
        });
      }));
    });

    controller.setProperties({
      filterTimes: [
        Ember.Object.create({ selected: false, fkey: "y", fval: "Upcoming" }),
        Ember.Object.create({ selected: false, fkey: "y", fval: "2010s" }),
        Ember.Object.create({ selected: false, fkey: "y", fval: "2000s" }),
        Ember.Object.create({ selected: false, fkey: "y", fval: "1990s" }),
        Ember.Object.create({ selected: false, fkey: "y", fval: "1980s" }),
        Ember.Object.create({ selected: false, fkey: "y", fval: "1970s" }),
        Ember.Object.create({ selected: false, fkey: "y", fval: "Older" })
      ],

      filterUserCount: [],
      filterStudios: [],
      filterRating: [],

      filterSorts: [
        { name: "Highest Rated", value: "rating" },
        { name: "Most Popular", value: "popular" },
        { name: "Newest", value: "newest" },
        { name: "Oldest", value: "oldest" }
      ],

      manuallyTriggered: false
    });

    if(controller.get('query.length') > 10){
      controller.decodeQuery();
    }
  }

});
