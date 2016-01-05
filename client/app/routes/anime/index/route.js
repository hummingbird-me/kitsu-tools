import Ember from 'ember';

const {
  Route,
  get,
  merge,
  typeOf,
  isEmpty
} = Ember;

export default Route.extend({
  queryParams: {
    ageRating: { refreshModel: true, replace: true },
    averageRating: { replace: true },
    episodeCount: { replace: true },
    genres: { refreshModel: true, replace: true },
    streamers: { refreshModel: true, replace: true },
    text: { refreshModel: true, replace: true },
    year: { replace: true }
  },

  model(params) {
    const limits = {
      page: { offset: 0, limit: 20 }
    };
    const filters = this._buildFilters(params);
    const options = merge(filters, limits);
    return get(this, 'store').query('anime', options);
  },

  serializeQueryParam(value, _, defaultValueType) {
    if (defaultValueType === 'array') {
      let _value = value;
      const isRange = typeOf(_value[0]) !== 'string';
      if (isRange === true && _value.length === 2) {
        _value = _value.join('..');
      } else if (isRange === false && _value.length > 1) {
        _value = _value.reject((x) => isEmpty(x)).join(',');
      } else {
        _value = _value.join();
      }
      return _value;
    }
    return this._super(...arguments);
  },

  deserializeQueryParam(value, _, defaultValueType) {
    if (defaultValueType === 'array') {
      let _value = value;
      const isRange = _value.includes('..');
      if (isRange === true) {
        _value = _value.split('..').map((x) => {
          if (Number.isInteger(JSON.parse(x))) {
            return parseInt(x, 10);
          } else {
            return parseFloat(x);
          }
        });
      } else if (isRange === false) {
        _value = _value.split(',');
      }
      return _value;
    }
    return this._super(...arguments);
  },

  _buildFilters(params) {
    const filters = { filter: {} };
    for (const key in params) {
      const val = params[key];
      if (isEmpty(val) === true) {
        continue;
      }
      const type = typeOf(val);
      filters.filter[key] = this.serializeQueryParam(val, key, type);
    }
    if (filters.filter.text === undefined) {
      filters.sort = '-user_count';
    }
    return filters;
  },

  actions: {
    refreshModel() {
      this.refresh();
    }
  }
});
