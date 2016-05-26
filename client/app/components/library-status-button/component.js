import Component from 'ember-component';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import computed from 'ember-computed';
import RSVP from 'rsvp';
import { task } from 'ember-concurrency';
import service from 'ember-service/inject';
import libraryStatus from 'client/utils/library-status';

const REMOVE_KEY = 'library.remove';

/**
 * For the loading state of this Component to work, the actions passed must
 * return Promises.
 */
export default Component.extend({
  entryIsLoaded: false,
  i18n: service(),

  /**
   * Current status of the library entry
   */
  currentStatus: computed('entry.status', 'mediaType', {
    get() {
      const status = get(this, 'entry.status');
      const media = get(this, 'mediaType');
      return get(this, 'i18n').t(`library.statuses.${media}.${status}`).toString();
    }
  }),

  /**
   * List of all statuses available for choice to the user
   */
  statuses: computed('entry', 'currentStatus', 'mediaType', {
    get() {
      const media = get(this, 'mediaType');
      const statuses = libraryStatus.getEnumKeys().map((key) => {
        return {
          key,
          string: get(this, 'i18n').t(`library.statuses.${media}.${key}`).toString()
        };
      });
      if (get(this, 'entry') === undefined) {
        return statuses;
      } else {
        const status = get(this, 'currentStatus');
        statuses.splice(statuses.findIndex((el) => el.string === status), 1);
        const removeKey = get(this, 'i18n').t(REMOVE_KEY).toString();
        return statuses.concat([{ key: REMOVE_KEY, string: removeKey }]);
      }
    }
  }),

  /**
   * This component can be created while waiting on a response from the server.
   * If the promise is passed, then resolve it and let the component know we
   * have the data.
   */
  didInitAttrs() {
    this._super(...arguments);
    const promise = get(this, 'promise');
    RSVP.resolve(promise).then(() => set(this, 'entryIsLoaded', true));
  },

  /**
   * We use this task to show the user a loading state while we wait for the
   * promises to resolve.
   */
  updateTask: task(function *(status) {
    const entry = get(this, 'entry');
    // Entry has loaded but is still undefined (doesn't exist)
    if (entry === undefined && get(this, 'entryIsLoaded')) {
      yield get(this, 'create')(status.key);
    } else if (entry !== undefined) {
      // User wants to delete the entry
      if (status.key === REMOVE_KEY) {
        yield get(this, 'delete')();
      } else {
        yield get(this, 'update')(status.key);
      }
    }
  }).drop()
});
