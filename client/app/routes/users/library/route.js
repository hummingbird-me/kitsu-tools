import Ember from 'ember';

const {
  Route,
  get,
  set
} = Ember;

// TODO: Handle other media types
// TODO: Map text status to numeric status
export default Route.extend({
  queryParams: {
    media: { refreshModel: true }
  },

  model(params) {
    // TODO: If status is NaN (??) handle
    return this._getLibraryData(params.media, params.status);
  },

  setupController(controller, model) {
    this._super(...arguments);
    set(controller, 'isLoadingData', true);
    // TODO: Return the statuses that aren't the param
    const params = this.paramsFor('users.Library');
    this._getLibraryData(params.media, '2,3,4,5')
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
      include: media,
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
  }
});
