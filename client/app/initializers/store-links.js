import Ember from 'ember';
import Store from 'ember-data/store';

const {
  get
} = Ember;

/**
* Stores the JSON-API `links` top-level object into the model's metadata.
* Simple hack to support pagination.
*
* Watch for updates in ED @ https://github.com/emberjs/data/issues/2905
**/
export function initialize() {
  Store.reopen({
    push(data) {
      const records = this._super(...arguments);
      if (records.length > 0) {
        if (data.links !== undefined) {
          data.meta = data.meta || {};
          data.meta._links = data.links;
          const model = get(records, 'firstObject');
          // no records being pushed into store
          if (model === undefined) {
            return records;
          }
          this._setMetadataFor(model.constructor.modelName, data.meta);
        }
      }
      return records;
    }
  });
}

export default {
  name: 'store-links',
  initialize
};
