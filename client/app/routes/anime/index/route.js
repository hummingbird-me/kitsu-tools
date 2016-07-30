import Route from 'ember-route';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import { assign } from 'ember-platform';
import { typeOf, isEmpty } from 'ember-utils';
import { bind, debounce } from 'ember-runloop';
import { isEmberArray } from 'ember-array/utils';
import jQuery from 'jquery';
import RSVP from 'rsvp';

const DEBOUNCE_MS = 1000;

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

  // TODO: Can be moved to Routable Component
  setupController(controller) {
    this._super(...arguments);
    jQuery(document).on('scroll', bind(controller, '_handleScroll'));
  },

  // TODO: Can be moved to Routable Component
  resetController() {
    this._super(...arguments);
    jQuery(document).off('scroll');
  },

  /**
   * Serializes range and array query params.
   * This is private Ember API.
   */
  serializeQueryParam(value, _, defaultValueType) {
    if (defaultValueType === 'array') {
      if (typeOf(value) !== 'array') {
        value = this.deserializeQueryParam(...arguments);
      }
      const isRange = typeOf(value[0]) !== 'string';
      if (isRange && value.length === 2) {
        return value.join('..');
      } else if (!isRange && value.length > 1) {
        return value.reject((x) => isEmpty(x)).join();
      }
      return value.join();
    }
    return this._super(...arguments);
  },

  /**
   * Deserializes range and array query params.
   * This is private Ember API.
   */
  deserializeQueryParam(value, _, defaultValueType) {
    if (defaultValueType === 'array') {
      const isRange = value.includes('..');
      if (isRange) {
        return value.split('..').map((x) => {
          if (Number.isInteger(JSON.parse(x))) {
            return parseInt(x, 10);
          } else {
            return parseFloat(x);
          }
        });
      }
      return value.split(',');
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

  /**
   * Build the filters object for the JSON-API, based on our query params.
   */
  _buildFilters(params) {
    const filters = { filter: {} };
    for (let key in params) {
      const val = params[key];
      // don't include empty values
      if (isEmpty(val) === true) {
        continue;
      } else if (isEmberArray(val) === true) {
        const filtered = val.reject((x) => isEmpty(x));
        if (isEmpty(filtered) === true) {
          continue;
        }
      }
      const type = typeOf(val);
      filters.filter[key] = this.serializeQueryParam(val, key, type);
    }
    if (filters.filter.text === undefined) {
      filters.sort = '-user_count';
    }
    return filters;
  },

  _updateText(query) {
    const controller = get(this, 'controller');
    set(controller, 'text', query);
  },

  actions: {
    updateText(query) {
      debounce(this, '_updateText', query, DEBOUNCE_MS);
    },

    updateNextPage(records, links) {
      const model = this.modelFor(get(this, 'routeName'));
      const content = get(model, 'media').toArray();
      content.addObjects(records);
      set(model, 'media', content);
      set(model, 'media.links', links);
    },

    refresh() {
      this.refresh();
    }
  }
});
