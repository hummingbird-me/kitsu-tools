import Ember from 'ember';
/* global Messenger */

export default Ember.ArrayController.extend({
  needs: "user",
  user: Ember.computed.alias('controllers.user'),
  reactComponent: null,

  filter: "",
  sortBy: JSON.parse(localStorage.getItem('librarySortBy')) || "lastWatched",
  sortAsc: JSON.parse(localStorage.getItem('librarySortAsc')) || false,
  sectionNames: ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"],
  showSection: "Currently Watching",

  showAll: function () {
    return this.get('showSection') === "View All" || this.get('filter').length > 0;
  }.property('showSection', 'filter'),

  sections: function () {
    var that;
    that = this;
    return this.get('sectionNames').map(function (name) {
      return Ember.Object.create({
        title: name,
        content: [],
        visible: (name === that.get('showSection')) || that.get('showAll'),
        displayVisible: (name === that.get('showSection')) && !that.get('showAll')
      });
    });
  }.property('sectionNames'),

  updateSectionVisibility: function () {
    var that;
    that = this;
    return this.get('sections').forEach(function (section) {
      var name;
      name = section.get('title');
      return section.setProperties({
        visible: (name === that.get('showSection')) || that.get('showAll'),
        displayVisible: (name === that.get('showSection')) && !that.get('showAll')
      });
    });
  }.observes('showSection', 'showAll'),

  updateSectionContents: function () {
    var agg, filter, sortAsc, sortProperty;
    agg = {};
    filter = this.get('filter').toLowerCase();
    sortProperty = this.get('sortBy');
    sortAsc = this.get('sortAsc') ? 1 : -1;

    this.get('sectionNames').forEach(function (name) {
      return agg[name] = [];
    });

    this.get('content').forEach(function (item) {
      if ((filter.length === 0) || (item.get('anime.searchString').indexOf(filter) >= 0)) {
        return agg[item.get('status')].push(item);
      }
    });
    return this.get('sections').forEach(function (section) {
      var sortedContent;
      sortedContent = agg[section.get('title')].sort(function (a, b) {
        var aProp, bProp;
        aProp = a.get(sortProperty);
        bProp = b.get(sortProperty);

        if (aProp < bProp) {
          return -1 * sortAsc;
        } else if (aProp === bProp) {
          return 0;
        } else {
          return 1 * sortAsc;
        }
      });
      return section.set('content', sortedContent);
    });
  }.observes('content.@each.status', 'filter', 'sortBy', 'sortAsc'),

  actuallyNotifyReactComponent: function () {
    if (this.get('reactComponent')) {
      return this.get('reactComponent').forceUpdate();
    }
  },

  notifyReactComponent: function () {
    return Ember.run.once(this, 'actuallyNotifyReactComponent');
  }.observes('filter', 'showSection', 'sortBy', 'sortAsc',
             'content.@each.episodesWatched',
             'content.@each.status',
             'content.@each.rating',
             'content.@each.private',
             'content.@each.episodesWatched',
             'content.@each.notes',
             'content.@each.rewatchCount',
             'content.@each.rewatching'),

  persistSort: function () {
    localStorage.setItem('librarySortBy', JSON.stringify(this.get('sortBy')));
    return localStorage.setItem('librarySortAsc', JSON.stringify(this.get('sortAsc')));
  }.observes('sortBy', 'sortAsc'),

  saveLibraryEntry: function (libraryEntry) {
    var title;
    title = libraryEntry.get('anime.canonicalTitle');
    return Messenger().expectPromise((function () {
      return libraryEntry.save();
    }), {
      progressMessage: "Saving " + title + "...",
      successMessage: "Saved " + title + "!"
    });
  },

  actions: {
    setSort: function (newSort) {
      if (this.get('sortBy') === newSort) {
        if (this.get('sortAsc')) {
          return this.set('sortAsc', false);
        } else {
          return this.set('sortBy', 'lastWatched');
        }
      } else {
        this.set('sortBy', newSort);
        return this.set('sortAsc', true);
      }
    },

    showSection: function (section) {
      if (typeof section === "string") {
        return this.set('showSection', section);
      } else {
        return this.set('showSection', section.get('title'));
      }
    },

    setStatus: function (libraryEntry, newStatus) {
      libraryEntry.set('status', newStatus);

      if (newStatus === "Completed" && libraryEntry.get('anime.episodeCount') && libraryEntry.get('episodesWatched') !== libraryEntry.get('anime.episodeCount')) {
        libraryEntry.set('episodesWatched', libraryEntry.get('anime.episodeCount'));
        Messenger().post("Marked all episodes as watched.");
      }

      return this.saveLibraryEntry(libraryEntry);
    },

    removeFromLibrary: function (libraryEntry) {
      var anime;
      anime = libraryEntry.get('anime');
      return Messenger().expectPromise((function () {
        return libraryEntry.destroyRecord();
      }), {
        progressMessage: "Removing " + anime.get('canonicalTitle') + " from your library...",
        successMessage: "Removed " + anime.get('canonicalTitle') + " from your library!"
      });
    },

    setPrivate: function (libraryEntry, newPrivate) {
      libraryEntry.set('private', newPrivate);
      return this.saveLibraryEntry(libraryEntry);
    },

    setRating: function (libraryEntry, newRating) {
      if (libraryEntry.get('rating') === newRating) {
        newRating = null;
      }
      libraryEntry.set('rating', newRating);
      return this.saveLibraryEntry(libraryEntry);
    },

    toggleRewatching: function (libraryEntry) {
      var currentState;
      currentState = libraryEntry.get('rewatching');
      if (currentState) {
        libraryEntry.set('rewatching', false);
      } else {
        libraryEntry.set('rewatching', true);
        if (libraryEntry.get('status') !== "Currently Watching") {
          libraryEntry.set('status', "Currently Watching");
          libraryEntry.set('episodesWatched', 0);
          Messenger().post("Moved " + libraryEntry.get('anime.canonicalTitle') + " to Currently Watching.");
        }
      }
      return this.saveLibraryEntry(libraryEntry);
    },

    saveLibraryEntry: function (libraryEntry) {
      return this.saveLibraryEntry(libraryEntry);
    },

    saveEpisodesWatched: function (libraryEntry) {
      if (libraryEntry.get('anime.episodeCount') && libraryEntry.get('episodesWatched') === libraryEntry.get('anime.episodeCount')) {
        if (libraryEntry.get('status') !== "Completed") {
          Messenger().post("Marked " + libraryEntry.get('anime.canonicalTitle') + " as complete.");
          libraryEntry.set('status', "Completed");
        }
      }
      return this.saveLibraryEntry(libraryEntry);
    }
  }
});
