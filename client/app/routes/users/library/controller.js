import Controller from 'ember-controller';
import computed, { alias } from 'ember-computed';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import service from 'ember-service/inject';
import libraryStatus from 'client/utils/library-status';

export default Controller.extend({
  queryParams: ['media', 'status'],
  media: 'anime',
  status: 1,
  showAll: false,
  filterQuery: undefined,
  entries: alias('model'),
  i18n: service(),

  // Returns the statuses in an array of { key, string }
  statuses: computed('media', {
    get() {
      const media = get(this, 'media');
      return libraryStatus.getEnumKeys().map((key) => {
        return {
          key,
          string: get(this, 'i18n').t(`library.statuses.${media}.${key}`).toString()
        };
      });
    }
  }).readOnly(),

  // Sort the library entries into an array of { status, entries }
  sections: computed('statuses', 'entries.@each.{status,isDeleted}', {
    get() {
      return get(this, 'statuses').map((status) => {
        const entries = get(this, 'entries')
          .filterBy('status', status.key)
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
  currentStatus: computed('status', 'statuses', {
    get() {
      const status = get(this, 'status');
      return get(this, 'statuses')[status - 1];
    }
  }),

  actions: {
    showAll() {
      set(this, 'showAll', true);
    },

    hideAll() {
      set(this, 'showAll', false);
    },

    filter(query) {
      set(this, 'filterQuery', query);
      get(this, 'sections').forEach((section) => {
        const entries = get(this, 'entries').filter((entry) => {
          const status = get(section, 'status').key;
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
