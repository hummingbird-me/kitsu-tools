import RecordArray from 'ember-data/-private/system/record-arrays/adapter-populated-record-array';

/**
* Stores the JSON-API `links` top-level object into the model's metadata.
* Simple hack to support pagination.
*
* Watch for updates in ED @ https://github.com/emberjs/data/issues/2905
**/
export function initialize() {
  RecordArray.reopen({
    loadRecords(records, payload) {
      payload.meta = payload.meta || {};
      payload.meta._links = payload.links;
      this._super(records, payload);
    }
  });
}

export default {
  name: 'store-links',
  initialize
};
