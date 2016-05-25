import Route from 'ember-route';
import get, { getProperties } from 'ember-metal/get';
import set, { setProperties } from 'ember-metal/set';
import jQuery from 'jquery';

// TODO: Performance (uhhh)! WTB Glimmer2, WTB <> Components, PLEASE
export default Route.extend({
  queryParams: {
    media: { refreshModel: true },
    status: { replace: true }
  },

  model({ media, status }) {
    return this._getLibraryData(media, status || 1);
  },

  setupController(controller, model) {
    this._super(...arguments);
    const { media, status } = getProperties(controller, 'media', 'status');

    // TODO: This needs to rerun when `media` is changed.
    const statuses = this._getNextStatuses(status);
    this._getLibraryData(media, statuses)
      .then((records) => {
        const content = model.toArray();
        content.addObjects(records);
        set(controller, 'model', content);
        set(controller, 'dataLoaded', true);
      });
  },

  titleToken() {
    const model = this.modelFor('users');
    const name = get(model, 'name');
    return `${name}'s Library`;
  },

  /**
   * Requests the library data for the user, media, and status.
   */
  _getLibraryData(media, status) {
    const user = this.modelFor('users');
    const userId = get(user, 'id');
    return get(this, 'store').query('library-entry', {
      include: `media.genres,user`,
      filter: {
        // jscs:disable
        user_id: userId,
        media_type: media.capitalize(),
        // jscs:enable
        status
      },
      page: {
        offset: 0,
        limit: 20000 /* Maybe change to -1? */
      }
    });
  },

  /**
   * Returns the statuses that we don't currently have as a joined string.
   */
  _getNextStatuses(status) {
    const statuses = [1, 2, 3, 4, 5];
    const index = statuses.indexOf(status);
    statuses.splice(index, 1);
    return statuses.join(',');
  },

  actions: {
    /**
     * Updates properties on the `entry` object passed.
     * Supports single property update, or multiple.
     */
    updateEntry(entry, key, value) {
      if (jQuery.isPlainObject(key)) {
        setProperties(entry, key);
      } else {
        set(entry, key, value);
      }
    },

    saveEntry(entry) {
      return entry.save()
        .catch((err) => console.error(err));
    },

    destroyEntry(entry) {
      return entry.destroyRecord()
        .catch((err) => console.error(err));
    }
  }
});
