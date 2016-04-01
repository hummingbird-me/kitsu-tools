import Component from 'ember-component';
import computed, { alias } from 'ember-computed';
import get from 'ember-metal/get';
import set, { setProperties } from 'ember-metal/set';
import { debounce } from 'ember-runloop';
import { isEmpty } from 'ember-utils';
import service from 'ember-service/inject';
import IsViewingSelfMixin from 'client/mixins/is-viewing-self';
import EmberValidations from 'ember-validations';

const DEBOUNCE = 1000;

// TODO: Update rating to support different rating systems
export default Component.extend(IsViewingSelfMixin, EmberValidations, {
  isOpened: false,
  validations: {
    'entry.episodesWatched': {
      numericality: {
        onlyInteger: true,
        greaterThanOrEqualTo: 0,
        lessThanOrEqualTo: 500
      }
    },
    'entry.rewatchCount': {
      numericality: {
        onlyInteger: true,
        greaterThanOrEqualTo: 0,
        lessThanOrEqualTo: 50
      }
    }
  },

  media: alias('entry.anime'),
  user: alias('entry.user'),
  currentSession: service(),

  episodeCountDisplay: computed('media.episodeCount', {
    get() {
      return get(this, 'media.episodeCount') || '?';
    }
  }),

  ratingDisplay: computed('entry.rating', {
    get() {
      return get(this, 'entry.rating') || '—';
    }
  }),

  typeDisplay: computed('media.showTypeStr', {
    get() {
      return get(this, 'media.showTypeStr');
    }
  }),

  _saveEntry() {
    // TODO: Feedback to user
    if (get(this, 'isValid') === true) {
      get(this, 'entry').save();
    }
  },

  actions: {
    toggleDisplay() {
      this.toggleProperty('isOpened');
    },

    update(target, value) {
      const entry = get(this, 'entry');
      if (isEmpty(value) === true || get(entry, target) === value) {
        return;
      }
      set(entry, target, value);
      debounce(this, '_saveEntry', DEBOUNCE);
    },

    rewatch() {
      const entry = get(this, 'entry');
      const count = get(entry, 'rewatchCount') + 1;
      setProperties(entry, {
        rewatchCount: count,
        episodesWatched: 0,
        status: 'current'
      });
      this._saveEntry();
    },

    updateState() {
      const entry = get(this, 'entry');
      const state = get(entry, 'private');
      set(entry, 'private', !state);
      this._saveEntry();
    }
  }
});
