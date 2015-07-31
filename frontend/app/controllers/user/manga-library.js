import Ember from 'ember';
/* global Messenger */

export default Ember.ArrayController.extend({
  needs: "user",
  user: Ember.computed.alias('controllers.user'),
  reactComponent: null,

  filter: "",
  sortBy: JSON.parse(localStorage.getItem('mangaLibrarySortBy')) || "lastRead",
  sortAsc: JSON.parse(localStorage.getItem('mangaLibrarySortAsc')) || false,

  sectionNames: ["Currently Reading", "Plan to Read", "Completed", "On Hold", "Dropped"],
  showSection: "Currently Reading",
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
      if ((filter.length === 0) || (item.get('manga.searchString').indexOf(filter) >= 0)) {
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
             'content.@each.chaptersRead',
             'content.@each.status',
             'content.@each.rating',
             'content.@each.private',
             'content.@each.rereadCount',
             'content.@each.rereading'),

  persistSort: function () {
    localStorage.setItem('mangaLibrarySortBy', JSON.stringify(this.get('sortBy')));
    return localStorage.setItem('mangaLibrarySortAsc', JSON.stringify(this.get('sortAsc')));
  }.observes('sortBy', 'sortAsc'),

  saveMangaLibraryEntry: function (libraryEntry) {
    var title;
    title = libraryEntry.get('manga.romajiTitle');
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
          return this.set('sortBy', 'lastRead');
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

      if (newStatus === "Completed" && libraryEntry.get('manga.chapterCount') && libraryEntry.get('chaptersRead') !== libraryEntry.get('manga.chapterCount')) {
        libraryEntry.set('chaptersRead', libraryEntry.get('manga.chapterCount'));
        Messenger().post("Marked all chapters as Read.");
      }

      return this.saveMangaLibraryEntry(libraryEntry);
    },

    removeFromMangaLibrary: function (libraryEntry) {
      var manga;
      manga = libraryEntry.get('manga');
      return Messenger().expectPromise((function () {
        return libraryEntry.destroyRecord();
      }), {
        progressMessage: "Removing " + manga.get('displayTitle') + " from your library...",
        successMessage: "Removed " + manga.get('displayTitle') + " from your library!"
      });
    },

    setVolumesRead: function(libraryEntry, newValue) {
      libraryEntry.set('volumesRead', newValue);
      return this.saveMangaLibraryEntry(libraryEntry);
    },

    setPrivate: function (libraryEntry, newPrivate) {
      libraryEntry.set('private', newPrivate);
      return this.saveMangaLibraryEntry(libraryEntry);
    },

    setRating: function (libraryEntry, newRating) {
      libraryEntry.set('rating', newRating);
      return this.saveMangaLibraryEntry(libraryEntry);
    },

    toggleRereading: function (libraryEntry) {
      var currentState;
      currentState = libraryEntry.get('rereading');
      if (currentState) {
        libraryEntry.set('rereading', false);
      } else {
        libraryEntry.set('rereading', true);
        if (libraryEntry.get('status') !== "Currently Reading") {
          libraryEntry.set('status', "Currently Reading");
          libraryEntry.set('chaptersRead', 0);
          Messenger().post("Moved " + libraryEntry.get('manga.displayTitle') + " to Currently Reading.");
        }
      }
      return this.saveMangaLibraryEntry(libraryEntry);
    },

    saveMangaLibraryEntry: function (libraryEntry) {
      return this.saveMangaLibraryEntry(libraryEntry);
    },

    saveChaptersRead: function (libraryEntry) {
      if (libraryEntry.get('manga.chapterCount') && libraryEntry.get('chaptersRead') === libraryEntry.get('manga.chapterCount')) {
        if (libraryEntry.get('status') !== "Completed") {
          Messenger().post("Marked " + libraryEntry.get('manga.displayTitle') + " as complete.");
          libraryEntry.set('status', "Completed");
        }
      }
      return this.saveMangaLibraryEntry(libraryEntry);
    }
  }
});
