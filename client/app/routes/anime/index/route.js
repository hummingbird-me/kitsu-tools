import Ember from 'ember';

const {
  Route,
  get
} = Ember;

export default Route.extend({
  queryParams: {
    text: { refreshModel: true, replaceState: true },
    year: { refreshModel: false, replaceState: true },
    averageRating: { refreshModel: false, replaceState: true },
    genres: { refreshModel: true, replaceState: true },
    streamers: { refreshModel: true, replaceState: true },
    ageRating: { refreshModel: true, replaceState: true },
    episodeCount: { refreshModel: false, replaceState: true }
  },

  model(params) {
    const limits = {
      page: {
        offset: 0,
        limit: 60
      }
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
      let val = params[key];
      if (val === null || val === undefined || val === '') continue;

      filters.filter[key] = val;
    }
    if (!filters.filter.text) filters.sort = '-user_count';
    return filters;
  },

  actions: {
    refreshModel: function () {
      this.refresh();
    }
  }
});
