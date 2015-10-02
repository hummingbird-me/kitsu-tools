import Ember from 'ember';

const {
  Component,
  on,
  run
} = Ember;

export default Component.extend({
  type: null,
  closable: true,

  _initializeFoundation: on('didInsertElement', function() {
    run.scheduleOnce('afterRender', this, () => {
      this.$().parent().foundation();
    });
  })
});
