import Route from 'ember-route';
import get from 'ember-metal/get';
import { assign } from 'ember-platform';
import { typeOf, isEmpty } from 'ember-utils';
import { bind } from 'ember-runloop';
import jQuery from 'jquery';
import RSVP from 'rsvp';

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
    return RSVP.hash({
      media: this._loadMediaData(params),
      genres: this._loadGenreData(),
      streamers: this._loadStreamerData(),
      ageRatings: ['G', 'PG', 'R', 'R18']
    });
  },

  // TODO: This should be moved to the eventual routable component which
  // won't be a singleton like the current controller (so it actually exits)
  setupController(controller) {
    this._super(...arguments);
    jQuery(document).on('scroll', bind(controller, '_handleScroll'));
  },

  deactivate() {
    jQuery(document).off('scroll');
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

  _loadMediaData(params) {
    const limit = { page: { offset: 0, limit: 20 } };
    const filters = this._buildFilters(params);
    const options = assign(filters, limit);
    return get(this, 'store').query('anime', options);
  },

  _loadGenreData() {
    const controller = this.controllerFor(get(this, 'routeName'));
    const data = get(controller, 'model.genres');
    if (isEmpty(data)) {
      return get(this, 'store').query('genre', {
        page: { offset: 0, limit: 20000 }
      });
    }
    return data;
  },

  _loadStreamerData() {
    const controller = this.controllerFor(get(this, 'routeName'));
    const data = get(controller, 'model.streamers');
    if (isEmpty(data)) {
      return get(this, 'store').query('streamer', {
        page: { offset: 0, limit: 20000 }
      });
    }
    return data;
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
