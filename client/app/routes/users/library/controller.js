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

  currentStatusStr: computed('status', {
    get() {
      const status = get(this, 'status');
      return libraryStatus.numberToHuman(status);
    }
  }),

  sections: computed('currentStatusStr', 'entries.[]', 'showAll', {
    get() {
      const currentStatusStr = get(this, 'currentStatusStr');
      return get(this, 'statuses').map((status) => {
        const entries = get(this, 'entries')
          .filterBy('status', libraryStatus.humanToEnum(status));
        return {
          status,
          entries,
          visible: (status === currentStatusStr) || get(this, 'showAll'),
          isActive: (status === currentStatusStr) && !get(this, 'showAll')
        };
      });
    }
  }),

  currentSection: computed('currentStatusStr', 'sections', {
    get() {
      const currentStatusStr = get(this, 'currentStatusStr');
      return get(this, 'sections').findBy('status', currentStatusStr);
    }
  }),

  actions: {
    showAllSections() {
      set(this, 'showAll', true);
    },

    changeSection(section) {
      const status = get(section, 'status');
      const numStatus = get(this, 'statuses').indexOf(status) + 1;
      setProperties(this, {
        showAll: false,
        status: numStatus
      });
    }
  }
});
