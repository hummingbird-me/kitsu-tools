import Ember from 'ember';

const {
  Component,
  run,
  inject: { service }
} = Ember;

export default Component.extend({
  currentSession: service(),

  didInsertElement() {
    this._super(...arguments);
    run.scheduleOnce('afterRender', this, () => {
      this.$().foundation();
    });
  }
});
