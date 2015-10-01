import Ember from 'ember';
import { RoutableComponentMixin } from 'client/mixins/routable-component';

const {
  Component,
  get,
  inject: { service }
} = Ember;

export default Component.extend(RoutableComponentMixin, {
  currentSession: service(),

  actions: {
    invalidateSession() {
      get(this, 'currentSession').invalidate();
    }
  }
});
