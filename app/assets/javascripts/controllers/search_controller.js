Hummingbird.SearchController = Ember.Controller.extend({
  searchResults: [],
  selectedFilter: null,
  searchTerm: "",
  filters: ["Everything", "Anime", "User"],

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

  hasSearchTerm: function () {
    return this.get('searchTerm').length !== 0;
  }.property('searchTerm'),

  filteredSearchResutlts: function () {
    var filter, filterd, results;
    results = this.get('searchResults');
    filter = this.get('selectedFilter');
    filterd = [];
    jQuery.each(results, function (index, item) {
      if (item.type === filter.toLowerCase() || filter === "Everything") {
        if (item.title !== "") {
          return filterd.push(item);
        }
      }
    });
    return filterd;
  }.property('searchResults', 'selectedFilter'),

  instantSearch: function () {
    var _this = this
      , blodhound = this.get('bhInstance')
      , searchterm = this.get('searchTerm');
    return blodhound.get(searchterm, function (suggestions) {
      suggestions.pop();
      return _this.set('searchResults', suggestions);
    });
  }.observes('searchTerm')
});
