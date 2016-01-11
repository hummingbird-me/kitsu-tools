import Ember from 'ember';
import moment from 'moment';
/* global humanizeDuration */

const {
  Component,
  computed,
  get
} = Ember;

// TODO: Support showing time
export default Component.extend({
  stats: computed('section', {
    get() {
      const entries = get(this, 'section.entries');
      const count = entries !== undefined ? entries.length : 0;
      const time = get(this, 'time');
      return `${count} titles — ${time}`;
    }
  }),

  time: computed('section', {
    get() {
      const entries = get(this, 'section.entries') || [];
      const time = moment.duration();
      entries.forEach((entry) => {
        const count = get(entry, 'anime.episodeCount');
        const length = get(entry, 'anime.episodeLength');
        time.add(count * length, 'minutes');
      });
      return humanizeDuration(time.asMilliseconds());
    }
  })
});
