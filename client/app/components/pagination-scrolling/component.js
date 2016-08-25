import Component from 'ember-component';
import get from 'ember-metal/get';
import { setProperties } from 'ember-metal/set';
import InViewportMixin from 'ember-in-viewport';
import PaginationMixin from 'client/mixins/pagination';

export default Component.extend(InViewportMixin, PaginationMixin, {
  tolerance: { top: 0, left: 0, bottom: 50, right: 0 },

  init() {
    this._super(...arguments);
    setProperties(this, {
      viewportSpy: true,
      viewportTolerance: get(this, 'tolerance')
    });
  },

  didEnterViewport() {
    this._super(...arguments);
    get(this, 'getNextData').perform().then(() => {
      // reset the viewport state, this is done because there is a possibility
      // that the component will still be within the viewport after the data
      // is retrieved, in which case a request will not be executed until
      // the component has left the viewport and re-entered.
      this._triggerDidAccessViewport(false);
    }).catch(() => {});
  }
});
