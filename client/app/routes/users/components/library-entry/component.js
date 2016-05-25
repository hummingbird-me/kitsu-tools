import Component from 'ember-component';
import computed, { alias } from 'ember-computed';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import service from 'ember-service/inject';
import { debounce, cancel } from 'ember-runloop';
import IsOwnerMixin from 'client/mixins/is-owner';
import EmberValidations from 'ember-validations';
import jQuery from 'jquery';

const DEBOUNCE_MS = 1000;

export default Component.extend(IsOwnerMixin, EmberValidations, {
  isExpanded: false,

  currentSession: service(),
  media: alias('entry.media'),
  user: alias('entry.user'),

  validations: {
    'entry.progress': {
      presence: true,
      numericality: {
        onlyInteger: true,
        greaterThanOrEqualTo: 0
      }
    },
    'entry.reconsumeCount': {
      presence: true,
      numericality: {
        onlyInteger: true,
        greaterThanOrEqualTo: 0
      }
    }
  },

  episodeCount: computed('media.episodeCount', {
    get() {
      return get(this, 'media.episodeCount') || '--';
    }
  }),

  rating: computed('entry.rating', {
    get() {
      return get(this, 'entry.rating') || '--';
    }
  }),

  /**
   * Toggle the `isExpanded` property when the component is clicked.
   * Returns early if the click is not within the desired container or
   * is within an input element.
   */
  click(event) {
    const target = get(event, 'target');
    const isChild = jQuery(target).is('.entry-wrapper *, .entry-wrapper');
    if (isChild === false || get(target, 'tagName') === 'INPUT') {
      return;
    }
    this.toggleProperty('isExpanded');
  },

  /**
   * Used for the `updateDebounced` action.
   */
  _save() {
    get(this, 'save')();
  },

  actions: {
    updateDebounced(key, value) {
      get(this, 'update')(key, value);
      return this.validate()
        .then(() => {
          const timer = debounce(this, '_save', DEBOUNCE_MS);
          set(this, 'debounceTimer', timer);
        })
        .catch(() => cancel(get(this, 'debounceTimer')));
    },

    update(key, value) {
      get(this, 'update')(key, value);
      if (get(this, 'isValid')) {
        return get(this, 'save')();
      }
    },

    destroy() {
      return get(this, 'delete')();
    },

    rewatch() {
      const reconsumeCount = get(this, 'entry.reconsumeCount') + 1;
      const updates = {
        reconsumeCount,
        progress: 0,
        status: 'current'
      };

      get(this, 'update')(updates);
      return this.validate().then(() => get(this, 'save')());
    }
  }
});
