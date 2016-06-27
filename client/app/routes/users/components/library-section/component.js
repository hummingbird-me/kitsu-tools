import Component from 'ember-component';
import computed from 'ember-computed';
import get from 'ember-metal/get';
import moment from 'moment';
/* global humanizeDuration */

export default Component.extend({
  stats: computed('section.entries', {
    get() {
      const entries = get(this, 'section.entries');
      const count = entries !== undefined ? entries.length : 0;
      const time = get(this, 'time');
      const text = count === 1 ? 'title' : 'titles';
      return `${count} ${text} — ${time}`;
    }
  }),

  // @TODO: Time is only relevent for anime and drama.
  time: computed('section.entries', {
    get() {
      const entries = get(this, 'section.entries') || [];
      const time = moment.duration();
      entries.forEach((entry) => {
        const count = get(entry, 'media.episodeCount');
        const length = get(entry, 'media.episodeLength');
        time.add(count * length, 'minutes');
      });
      return humanizeDuration(time.asMilliseconds());
    }
  })
});
