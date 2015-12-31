import Ember from 'ember';

const {
  Component,
  run
} = Ember;

export default Component.extend({
  didInsertElement() {
    run.scheduleOnce('afterRender', this, () => {
      this.$().foundation();
    });
  }
});
