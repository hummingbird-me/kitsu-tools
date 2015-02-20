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
      limit: 8,
      remote: {
        url: '/search.json?scope=all&depth=instant&query=%QUERY',
        filter: function(results) {
          return results.search;
        }
      }
    });
    bloodhound.initialize();
    return bloodhound;
  }.property(),

  // Decides whether the search field is collapsed or displayed initially.
  collapsed: true,

  updateSearchResults: function() {
    if (this.get('query').length > 2) {
      this.get('bloodhound').get(this.get('query'), (results) => {
        this.set('searchResults', results);
      });
    }
  },

  queryObserver: function() {
    Ember.run.debounce(this, this.updateSearchResults, 300);
  }.observes('query'),

  registerFocusHandlers: function() {
    var self = this;
    this.$("span").focusout(function() {
      // This won't be needed once we switch to using Ember transitions for
      // opening the search results.
      setTimeout(function() {
        Ember.run(function() { self.set('searchResults', []); });
      }, 300);
    });
    this.$("input").focus(function() {
      Ember.run(function() { self.updateSearchResults(); });
    });
  }.on('didInsertElement'),

  actions: {
    toggleSearchVisibility: function() {
      this.toggleProperty('collapsed');
      if (!this.get('collapsed')) {
        Ember.run.next(this, function() { this.$(".search-field").focus(); });
      }
    },

    submitQuery: function() {
      window.location.href = "/search?query=" + this.get('query');
    }
  }
});
