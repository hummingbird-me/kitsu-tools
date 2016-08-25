import Component from 'ember-component';
import computed from 'ember-computed';
import get from 'ember-metal/get';
import service from 'ember-service/inject';
import moment from 'moment';
/* global humanizeDuration */

export default Component.extend({
  i18n: service(),

  /**
   * Returns the i18n version of our status
   */
  statusName: computed('status', {
    get() {
      const status = get(this, 'status');
      const mediaType = get(this, 'mediaType');
      return get(this, 'i18n').t(`library.statuses.${mediaType}.${status}`);
    }
  }),

  /**
   * Displays the number of entries within this section
   */
  stats: computed('entries', {
    get() {
      const entries = get(this, 'entries');
      const count = entries !== undefined ? get(entries, 'length') : 0;
      const time = get(this, 'time');
      const text = count === 1 ? 'title' : 'titles';
      return `${count} ${text} — ${time}`;
    }
  }),

  /**
   * Displays the total time of all entries in this section
   * @TODO: Time is only relevent for anime and drama.
   */
  time: computed('entries', {
    get() {
      const entries = get(this, 'entries') || [];
      const time = moment.duration();
      entries.forEach((entry) => {
        const count = get(entry, 'media.episodeCount');
        const length = get(entry, 'media.episodeLength');
        time.add(count * length, 'minutes');
      });
      return humanizeDuration(time.asMilliseconds());
    }
  }),

  actions: {
    update(records) {
      get(this, 'update')(records);
    }
  }
});
