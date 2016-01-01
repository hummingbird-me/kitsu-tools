import Ember from 'ember';

const {
  Route,
  get
} = Ember;

export default Route.extend({
  queryParams: {
    text: { refreshModel: true, replaceState: true },
    year: { refreshModel: true, replaceState: true },
    averageRating: { refreshModel: true, replaceState: true },
    streamers: { refreshModel: true, replaceState: true },
    ageRating: { refreshModel: true, replaceState: true },
    episodeCount: { refreshModel: true, replaceState: true }
  },

  model(params) {
    const limits = {
      page: {
        offset: 0,
        limit: 20
      },
      sort: '-user_count'
    };
    const filters = this._buildFilters(params);
    // TODO: Includes
    const options = Object.assign(filters, limits);
    return get(this, 'store').query('anime', options);
  },

  _buildFilters(params) {
    // TODO: Build filters out correctly.
    const filters = { filter: {} };
    for (const key in params) {
      const val = params[key];
      if (val !== null || val !== undefined) {
        filters.filter[key] = val;
      }
    }
    return filters;
  }
});
