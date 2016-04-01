import Component from 'ember-component';
import get from 'ember-metal/get';
import set, { setProperties } from 'ember-metal/set';
import { debounce } from 'ember-runloop';
import computed from 'ember-computed';
import service from 'ember-service/inject';
import InViewportMixin from 'ember-in-viewport';

const DEBOUNCE = 500;

// TODO: See client/initializers/store-links.js comments
export default Component.extend(InViewportMixin, {
  isLoading: false,
  model: undefined,

  store: service(),

  nextLink: computed('_links', {
    get() {
      const links = get(this, '_links') || {};
      return get(links, 'next');
    }
  }),

  _links: computed('model', {
    get() {
      let model = get(this, 'model');
      const metadata = get(model, 'meta');
      return get(metadata, '_links');
    }
  }),

  didInsertElement() {
    this._super(...arguments);
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
    debounce(this, this._getNextData, DEBOUNCE, true);
  },

  _getNextData() {
    const nextLink = get(this, 'nextLink');
    if (nextLink === undefined || get(this, 'isLoading') === true) {
      return;
    }
    set(this, 'isLoading', true);
    let model = get(this, 'model');
    model = get(model, 'firstObject') || model;
    const { modelName } = model.constructor;
    const options = this._parseLink(nextLink);
    get(this, 'store').query(modelName, options)
      .then((records) => {
        // It's possible that the user navigated away during the ajax request
        // which has destroyed the component
        if (get(this, 'model') === undefined) {
          return;
        }
        // Add the records to our data
        const content = get(this, 'model').toArray();
        content.addObjects(records);
        set(this, 'model', content);
        // update meta record -_-'
        set(get(this, 'model'), 'meta', get(records, 'meta'));
        set(this, 'isLoading', false);
      });
  },

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
