import Ember from 'ember';

const {
  Component,
  computed,
  computed: { alias },
  get,
  inject: { service }
} = Ember;

// TODO: Update rating to support different rating systems
export default Component.extend({
  isOpened: false,
  media: alias('entry.anime'),
  currentSession: service(),

  isViewingSelf: computed('entry.user', 'currentSession.account', {
    get() {
      const user = get(this, 'entry.user');
      return get(this, 'currentSession').isCurrentUser(user);
    }
  }),

  personalNote: computed('media.canonicalTitle', {
    get() {
      const title = get(this, 'media.canonicalTitle');
      return `Personal notes about ${title}`;
    }
  }),

  episodeCount: computed('media.episodeCount', {
    get() {
      return get(this, 'media.episodeCount') || '?';
    }
  }),

  rating: computed('entry.rating', {
    get() {
      return get(this, 'entry.rating') || '—';
    }
  }),

  type: computed('media.showType', {
    get() {
      const showTypes = ['TV', 'Special', 'ONA', 'OVA', 'Movie', 'Music'];
      const showType = get(this, 'media.showType');
      return showTypes[showType - 1];
    }
  }),

  actions: {
    toggleDisplay() {
      this.toggleProperty('isOpened');
    }
  }
});
