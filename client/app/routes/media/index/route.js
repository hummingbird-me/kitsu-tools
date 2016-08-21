import Route from 'ember-route';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import { assert } from 'ember-metal/utils';
import { bind } from 'ember-runloop';
import { isEmpty, typeOf } from 'ember-utils';
import { isEmberArray } from 'ember-array/utils';
import { task, timeout } from 'ember-concurrency';
import jQuery from 'jquery';
import QueryableMixin from 'client/mixins/routes/queryable';

export default Route.extend(QueryableMixin, {
  mediaType: undefined,
  mediaQueryParams: {
    averageRating: { replace: true },
    genres: { refreshModel: true, replace: true },
    text: { refreshModel: true, replace: true },
    year: { replace: true }
  },
  templateName: 'media/index',

  setQuery: task(function *(value) {
    const controller = this.controllerFor(get(this, 'routeName'));
    set(controller, 'searchQuery', value);
    yield timeout(1000);
    set(controller, 'text', value);
  }).restartable(),

  init() {
    this._super(...arguments);
    const mediaType = get(this, 'mediaType');
    assert('Must provide a `mediaType` value', mediaType !== undefined);

    const mediaQueryParams = get(this, 'mediaQueryParams');
    const queryParams = get(this, 'queryParams') || {};
    set(this, 'queryParams', Object.assign(mediaQueryParams, queryParams));
  },

  beforeModel() {
    this._super(...arguments);
    return get(this, 'store').query('genre', {
      page: { offset: 0, limit: 20000 }
    }).then((results) => {
      const controller = this.controllerFor(get(this, 'routeName'));
      set(controller, 'availableGenres', results);
    });
  },

  model(params) {
    const limit = { page: { offset: 0, limit: 20 } };
    const filters = this._buildFilters(params);
    const options = Object.assign(filters, limit);
    const mediaType = get(this, 'mediaType');
    return get(this, 'store').query(mediaType, options);
  },

  setupController(controller) {
    this._super(...arguments);
    jQuery(document).on('scroll', bind(controller, '_handleScroll'));

    // apply text to searchQuery
    set(controller, 'searchQuery', get(controller, 'text'));
  },

  resetController() {
    this._super(...arguments);
    jQuery(document).off('scroll');
  },

  _buildFilters(params) {
    const filters = { filter: {} };
    for (let key in params) {
      const value = params[key];
      if (isEmpty(value) === true) {
        continue;
      } else if (isEmberArray(value) === true) {
        const filtered = value.reject((x) => isEmpty(x));
        if (isEmpty(filtered) === true) {
          continue;
        }
      }
      const type = typeOf(value);
      filters.filter[key] = this.serializeQueryParam(value, key, type);
    }
    if (filters.filter.text === undefined) {
      filters.sort = '-user_count';
    }
    return filters;
  },

  actions: {
    updateText(query) {
      get(this, 'setQuery').perform(query);
    },

    updateNextPage(records, links) {
      const controller = this.controllerFor(get(this, 'routeName'));
      const content = get(controller, 'model').toArray();
      content.addObjects(records);
      set(controller, 'model', content);
      set(controller, 'model.links', links);
    },

    refresh() {
      this.refresh();
    }
  }
});
