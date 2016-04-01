import Ember from 'ember';

const {
  Component,
  run,
  set
} = Ember;

export default Component.extend({
  classNames: ['poster-wrapper'],
  media: undefined,
  trailerId: undefined,
  trailerIsOpen: false,

  didInsertElement() {
    this._super(...arguments);
    run.scheduleOnce('afterRender', this, () => {
      this._updateTrailerId();
    });
  },

  _updateTrailerId() {
    const id = this.$().attr('id');
    set(this, 'trailerId', `media-trailer-${id}`);
  },

  actions: {
    showTrailer() {
      set(this, 'trailerIsOpen', true);
    }
  }
});
