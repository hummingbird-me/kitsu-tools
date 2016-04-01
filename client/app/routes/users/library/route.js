import Route from 'ember-route';
import get, { getProperties } from 'ember-metal/get';
import set from 'ember-metal/set';

// TODO: Handle other media types
// TODO: Map text status to numeric status
export default Route.extend({
  queryParams: {
    media: { refreshModel: true },
    status: { replace: true }
  },

  model(params) {
    return this._getLibraryData(params.media, params.status || 1);
  },

  setupController(controller, model) {
    this._super(...arguments);
    set(controller, 'isLoadingData', true);
    const { media, status } = getProperties(controller, 'media', 'status');
    this._getLibraryData(media, this._getNextStatuses(status))
      .then((records) => {
        const content = model.toArray();
        content.addObjects(records);
        set(controller, 'model', content);
        set(controller, 'isLoadingData', false);
      });
  },

  titleToken() {
    const model = this.modelFor('users');
    const name = get(model, 'name');
    return `${name}'s Library`;
  },

  _getLibraryData(media, status) {
    const user = this.modelFor('users');
    const userId = get(user, 'id');
    return get(this, 'store').query('library-entry', {
      include: `${media}.genres,user`,
      filter: {
        // jscs:disable
        user_id: userId,
        // jscs:enable
        status
      },
      page: {
        offset: 0,
        limit: 20000 /* Maybe change to -1? */
      }
    });
  },

  _getNextStatuses(status) {
    const statuses = [1, 2, 3, 4, 5];
    const index = statuses.indexOf(status);
    statuses.splice(index, 1);
    return statuses.join(',');
  }
});
