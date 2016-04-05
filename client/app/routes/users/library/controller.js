import Controller from 'ember-controller';
import computed, { alias } from 'ember-computed';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import libraryStatus from 'client/utils/library-status';

export default Controller.extend({
  queryParams: ['media', 'status'],
  media: 'anime',
  status: 1,
  showAll: false,
  entries: alias('model'),

  // Sort the library entries into an array of { status, entries }
  sections: computed('statuses', 'entries.@each.{status,isDeleted}', {
    get() {
      return get(this, 'statuses').map((status) => {
        const entries = get(this, 'entries')
          .filterBy('status', libraryStatus.humanToEnum(status))
          .filterBy('isDeleted', false);
        return { status, entries };
      });
    }
  }),

  // Returns the section that is currently active
  currentSection: computed('status', 'sections', {
    get() {
      const status = get(this, 'status');
      return get(this, 'sections')[status - 1];
    }
  }),

  // Get the human-readable status from the query parameter
  currentStatus: computed('status', {
    get() {
      const status = get(this, 'status');
      return libraryStatus.numberToHuman(status);
    }
  }),

  init() {
    this._super(...arguments);
    set(this, 'statuses', libraryStatus.getHumanStatuses());
  },

  actions: {
    showAll() {
      set(this, 'showAll', true);
    },

    hideAll() {
      set(this, 'showAll', false);
    },

    filter(query) {
      get(this, 'sections').forEach((section) => {
        const entries = get(this, 'entries').filter((entry) => {
          const status = libraryStatus.humanToEnum(get(section, 'status'));
          if (get(entry, 'status') !== status) {
            return false;
          }
          return get(entry, 'anime.mergedTitles').includes(query.toLowerCase());
        });
        set(section, 'entries', entries);
      });
      set(this, 'showAll', !!query.length);
    }
  }
});
