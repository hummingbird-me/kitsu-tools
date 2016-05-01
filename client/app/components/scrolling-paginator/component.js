import Component from 'ember-component';
import get from 'ember-metal/get';
import { setProperties } from 'ember-metal/set';
import computed from 'ember-computed';
import service from 'ember-service/inject';
import InViewportMixin from 'ember-in-viewport';
import { task } from 'ember-concurrency';

/**
 * Scrolling pagination based on JSON-API's top level links object.
 * Due to ember-data not having support for pagination yet, this requires a
 * hackish fix implemented in `client/initializers/store-links.js`
 */
export default Component.extend(InViewportMixin, {
  store: service(),

  /**
   * Grabs the latest `next` URL from the `links` object
   */
  nextLink: computed('links', {
    get() {
      const links = get(this, 'links') || {};
      return get(links, 'next');
    }
  }),

  /**
   * Grabs the `links` object from the models metadata
   */
  links: computed('model', {
    get() {
      let model = get(this, 'model');
      const metadata = get(model, 'meta');
      return get(metadata, '_links');
    }
  }),

  /**
   * Droppable task that queries the next set of data and sends an action
   * up to the owner.
   */
  getNextData: task(function *() {
    const nextLink = get(this, 'nextLink');
    if (nextLink === undefined) {
      return;
    }
    let model = get(this, 'model');
    model = get(model, 'firstObject') || model;
    const { modelName } = model.constructor;
    const options = this._parseLink(nextLink);
    const records = yield get(this, 'store').query(modelName, options);
    get(this, 'update')(records);
  }).drop(),

  init() {
    this._super(...arguments);
    // Setup properties for `ember-in-viewport`
    setProperties(this, {
      viewportSpy: true,
      viewportTolerance: {
        top: 50,
        bottom: 50
      }
    });
  },

  didEnterViewport() {
    this._super(...arguments);
    get(this, 'getNextData').perform();
  },

  /**
   * Decodes and rebuilds the query params object from the URL passed.
   */
  _parseLink(url) {
    url = window.decodeURI(url);
    url = url.split('?')[1].split('&');
    const filter = {};
    url.forEach((option) => {
      option = option.split('=');
      if (option[0].includes('[') === true) {
        const match = option[0].match(/(.+)\[(.+)\]/);
        filter[match[1]] = filter[match[1]] || {};
        filter[match[1]][match[2]] = decodeURIComponent(option[1]);
      } else {
        filter[option[0]] = decodeURIComponent(option[1]);
      }
    });
    return filter;
  }
});
