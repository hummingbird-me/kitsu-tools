import Ember from 'ember';
import libraryStatus from 'client/utils/library-status';

const {
  Controller,
  computed,
  computed: { alias },
  get,
  set,
  setProperties
} = Ember;

// TODO: Speed up rendering!!
export default Controller.extend({
  queryParams: ['media', 'status'],
  media: 'anime',
  status: 1,
  showAll: false,
  entries: alias('model'),

  statuses: computed({
    get() {
      return libraryStatus.getHumanStatuses();
    }
  }),

  activeStatus: computed('showAll', 'status', {
    get() {
      if (get(this, 'showAll')) {
        return;
      }
      const status = get(this, 'status');
      return libraryStatus.numberToHuman(status);
    }
  }),

  sections: computed('statuses', 'entries.@each.status', {
    get() {
      return get(this, 'statuses').map((status) => {
        const entries = get(this, 'entries')
          .filterBy('status', libraryStatus.humanToEnum(status));
        return { status, entries };
      });
    }
  }),

  currentSection: computed('status', 'sections', {
    get() {
      const status = get(this, 'status');
      return get(this, 'sections')[status - 1];
    }
  }),

  actions: {
    showAll() {
      set(this, 'showAll', true);
    },

    changeStatus(status) {
      setProperties(this, {
        showAll: false,
        status: libraryStatus.humanToNumber(status)
      });
    },

    filter(query) {
      get(this, 'sections').forEach((section) => {
        const entries = get(this, 'entries').filter((entry) => {
          const status = libraryStatus.humanToEnum(get(section, 'status'));
          if (get(entry, 'status') !== status) {
            return false;
          }
          return get(entry, 'anime.searchStr').includes(query.toLowerCase());
        });
        set(section, 'entries', entries);
      });
      set(this, 'showAll', !!query.length);
    }
  }
});
