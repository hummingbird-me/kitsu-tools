import Component from 'ember-component';
import set from 'ember-metal/set';

export default Component.extend({
  classNames: ['poster-wrapper'],
  trailerOpen: false,

  actions: {
    openTrailer() {
      this.$('').off('closed.zf.reveal').on('closed.zf.reveal', () => {
        set(this, 'trailerOpen', false);
      });
      set(this, 'trailerOpen', true);
    }
  }
});
