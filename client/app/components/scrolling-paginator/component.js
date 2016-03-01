import Ember from 'ember';
import InViewportMixin from 'ember-in-viewport';

const DEBOUNCE = 500;
const {
  Component,
  get,
  getWithDefault,
  set,
  setProperties,
  run,
  computed,
  inject: { service }
} = Ember;

// TODO: See client/initializers/store-links.js comments
export default Component.extend(InViewportMixin, {
  isLoading: false,
  model: undefined,

  store: service(),

  nextLink: computed('_links', {
    get() {
      const links = get(this, '_links') || {};
      return getWithDefault(links, 'next', undefined);
    }
  }),

  _links: computed('model', {
    get() {
      let model = get(this, 'model');
      const metadata = get(model, 'meta');
      return getWithDefault(metadata, '_links', undefined);
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
    this._super();
    run.debounce(this, this._getNextData, DEBOUNCE, true);
  },

  _getNextData() {
    const nextLink = get(this, 'nextLink');
    if (nextLink === undefined || get(this, 'isLoading') === true) {
      return;
    }
    set(this, 'isLoading', true);
    let model = get(this, 'model');
    model = getWithDefault(model, 'firstObject', model);
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
