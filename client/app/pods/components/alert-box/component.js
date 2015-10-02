import Ember from 'ember';

const {
  Component,
  on,
  run
} = Ember;

export default Component.extend({
  type: null,
  closable: true,

  // @Note: Fastboot does not invoke didInsertElement hooks
  // We might need to skip foundations javascript and close alerts by
  // using a `click` hook.
  _initializeFoundation: on('didInsertElement', function() {
    run.scheduleOnce('afterRender', this, () => {
      this.$().parent().foundation();
    });
  })
});
