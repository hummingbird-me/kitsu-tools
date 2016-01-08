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
  ajax: service(),

  nextLink: computed('_links', {
    get() {
      const links = get(this, '_links') || {};
      return getWithDefault(links, 'next', undefined);
    }
  }),

  _links: computed('model', {
    get() {
      let model = get(this, 'model');
      model = getWithDefault(model, 'firstObject', model);
      const modelName = get(model, 'constructor.modelName');
      if (modelName === undefined) {
        return undefined;
      }
      const metadata = get(this, 'store')._metadataFor(modelName);
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
    run.debounce(this, this._getNextData, DEBOUNCE, true);
  },

  _getNextData() {
    const nextLink = get(this, 'nextLink');
    if (nextLink === undefined || get(this, 'isLoading') === true) {
      return;
    }
    set(this, 'isLoading', true);
    get(this, 'ajax').request(nextLink, { includesHost: true })
      .then((response) => {
        // It's possible that the user navigated away during the ajax request
        // which has destroyed the component
        if (get(this, 'model') === undefined) {
          return;
        }
        // push the content into 'store' which will update the meta object for
        // this model, and give us the next 'nextLink'. Also add the current
        // content onto the controller.
        const records = get(this, 'store').push(response);
        const content = get(this, 'model').toArray();
        content.addObjects(records);
        set(this, 'model', content);
        set(this, 'isLoading', false);
      });
  }
});
