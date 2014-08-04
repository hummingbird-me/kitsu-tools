Hummingbird.SearchController = Ember.Controller.extend({
  queryParams: ['query', 'filter'],
  searchResults: [],
  filter: null,
  query: "",
  filters: ["Everything", "Anime", "Manga", "User"],

  init: function () {
    var bloodhound = new Bloodhound({
      datumTokenizer: function (d) {
        return Bloodhound.tokenizers.whitespace(d.value);
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/search.json?query=%QUERY&type=full',
        filter: function (results) {
          return Ember.$.map(results.search, function (r) {
            return {
              type: r.type,
              title: r.title,
              desc: r.desc,
              image: r.image,
              link: r.link,
              badges: r.badges
            };
          });
        }
      }
    });
    bloodhound.initialize();
    this.set('bhInstance', bloodhound);
    return this._super();
  },

  hasquery: function () {
    return this.get('query').length !== 0;
  }.property('query'),

  filteredSearchResutlts: function () {
    var filter, filterd, results;
    results = this.get('searchResults');
    filter = this.get('filter');
    filterd = [];
    jQuery.each(results, function (index, item) {
      if (item.type === filter.toLowerCase() || filter === "Everything") {
        if (item.title !== "") {
          return filterd.push(item);
        }
      }
    });
    return filterd;
  }.property('searchResults', 'filter'),

  instantSearch: function () {
    var _this = this
      , blodhound = this.get('bhInstance')
      , query = this.get('query');
    return blodhound.get(query, function (suggestions) {
      suggestions.pop();
      return _this.set('searchResults', suggestions);
    });
  }.observes('query')
});
