import Ember from 'ember';
import libraryStatus from 'client/utils/library-status';

const {
  Component,
  computed,
  computed: { alias },
  get
} = Ember;

// TODO: Update rating to support different rating systems
// TODO: Map type to text
export default Component.extend({
  isOpened: false,
  media: alias('entry.anime'),

  personalNote: computed('media.canonicalTitle', {
    get() {
      const title = get(this, 'media.canonicalTitle');
      return `Personal notes about ${title}`;
    }
  }),

  status: computed('entry.status', {
    get() {
      return libraryStatus.enumToHuman(get(this, 'entry.status'));
    }
  }),

  episodeCount: computed('media.episodeCount', {
    get() {
      return get(this, 'media.episodeCount') || '?';
    }
  }),

  rating: computed('entry.rating', {
    get() {
      return get(this, 'entry.rating') || '--';
    }
  }),

  type: computed('media.showType', {
    get() {
      return get(this, 'media.showType');
    }
  }),

  actions: {
    toggleDisplay() {
      this.toggleProperty('isOpened');
    }
  }
});
