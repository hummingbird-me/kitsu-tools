import Component from 'ember-component';
import get from 'ember-metal/get';
import service from 'ember-service/inject';

export default Component.extend({
  currentSession: service(),

  actions: {
    invalidateSession() {
      get(this, 'currentSession').invalidate();
    }
  }
});
