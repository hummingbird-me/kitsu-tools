import Component from 'ember-component';
import get from 'ember-metal/get';
import { setProperties } from 'ember-metal/set';
import computed from 'ember-computed';
import service from 'ember-service/inject';
import InViewportMixin from 'ember-in-viewport';
import { task } from 'ember-concurrency';

/**
 * Scrolling pagination based on JSON-API's top level links object.
 *
 * When this component enters the viewport it requests the next set of data
 * based on the `next` link within the `links` object. Those new records are
 * then sent up to be handled.
 */
export default Component.extend(InViewportMixin, {
  store: service(),

  /**
   * Grabs the latest `next` URL from the `links` object
   */
  nextLink: computed('model', {
    get() {
      const model = get(this, 'model');
      const links = get(model, 'links') || {};
      return get(links, 'next') || undefined;
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
    const links = get(records, 'links');
    get(this, 'update')(records, links);
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
    url = url.split('?');
    if (url.length !== 2) {
      return {};
    }
    url = url[1].split('&');
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
