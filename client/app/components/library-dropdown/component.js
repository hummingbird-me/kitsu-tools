import Component from 'ember-component';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import computed from 'ember-computed';
import { task } from 'ember-concurrency';
import { assert } from 'ember-metal/utils';
import service from 'ember-service/inject';
import libraryStatus from 'client/utils/library-status';
import RSVP from 'rsvp';

const REMOVE_KEY = 'library.remove';

export default Component.extend({
  entryIsLoaded: false,
  i18n: service(),

  currentStatus: computed('entry.status', {
    get() {
      const entry = get(this, 'entry');
      const status = get(entry, 'status');
      const type = get(this, 'mediaType');
      return get(this, 'i18n').t(`library.statuses.${type}.${status}`).toString();
    }
  }).readOnly(),

  statuses: computed('entry', 'currentStatus', {
    get() {
      const type = get(this, 'mediaType');
      const statuses = libraryStatus.getEnumKeys().map((key) => {
        return {
          key,
          string: get(this, 'i18n').t(`library.statuses.${type}.${key}`).toString()
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
  }).readOnly(),

  updateTask: task(function *(status) {
    const entry = get(this, 'entry');
    if (entry === undefined && get(this, 'entryIsLoaded') === true) {
      yield get(this, 'create')(status.key);
    } else if (entry !== undefined) {
      if (status.key === REMOVE_KEY) {
        yield get(this, 'delete')();
      } else {
        yield get(this, 'update')(status.key);
      }
    }
  }).drop(),

  init() {
    this._super(...arguments);
    assert('`{{library-dropdown}}` requires a `mediaType` param',
      get(this, 'mediaType') !== undefined);
    assert('`{{library-dropdown}}` requires a `promise` param when `entry` is undefined',
      (get(this, 'promise') !== undefined && get(this, 'entry') === undefined) ||
      (get(this, 'promise') === undefined && get(this, 'entry') !== undefined));

    const promise = get(this, 'promise');
    RSVP.resolve(promise).then(() => set(this, 'entryIsLoaded', true));
  }
});
