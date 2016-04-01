import Component from 'ember-component';
import { scheduleOnce } from 'ember-runloop';
import service from 'ember-service/inject';

export default Component.extend({
  currentSession: service(),

  didInsertElement() {
    this._super(...arguments);
    scheduleOnce('afterRender', this, () => {
      this.$().foundation();
    });
  }
});
