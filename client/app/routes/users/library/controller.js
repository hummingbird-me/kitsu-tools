import Controller from 'ember-controller';
import computed, { alias } from 'ember-computed';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import libraryStatus from 'client/utils/library-status';

export default Controller.extend({
  queryParams: ['media', 'status'],
  media: 'anime',
  status: 'current',

  entries: alias('model'),

  /**
   * Returns an array of the other library page options
   */
  mediaList: computed('media', {
    get() {
      const list = ['anime', 'drama', 'manga'];
      const media = get(this, 'media');
      list.splice(list.findIndex((m) => m === media), 1);
      return list;
    }
  }).readOnly(),

  /**
   * Filters the entries by their status and state into an object of
   * `{ status: entries, ... }`
   */
  sections: computed('entries.@each.{status,isDeleted}', {
    get() {
      const sections = {};
      get(this, 'statuses').slice(1).forEach((status) => {
        const entries = get(this, 'entries')
          .filterBy('status', status)
          .filterBy('isDeleted', false);
        sections[status] = entries;
      });
      return sections;
    }
  }).readOnly(),

  /**
   * Gets the filtered entries for the current status
   */
  filteredEntries: computed('status', 'sections', {
    get() {
      const status = get(this, 'status');
      return get(this, 'sections')[status];
    }
  }).readOnly(),

  init() {
    this._super(...arguments);
    set(this, 'statuses', ['all', ...libraryStatus.getEnumKeys()]);
  }
});
