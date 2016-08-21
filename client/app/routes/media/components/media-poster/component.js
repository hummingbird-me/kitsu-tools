import Component from 'ember-component';
import set from 'ember-metal/set';
import get from 'ember-metal/get';
import getter from 'client/utils/getter';

export default Component.extend({
  classNames: ['poster-wrapper'],
  media: undefined,
  trailerOpen: false,

  isAnime: getter(function() {
    return get(this, 'media').constructor.modelName === 'anime';
  }),

  isDrama: getter(function() {
    return get(this, 'media').constructor.modelName === 'drama';
  }),

  isManga: getter(function() {
    return get(this, 'media').constructor.modelName === 'manga';
  }),

  mediaRoute: getter(function() {
    return `${get(this, 'media').constructor.modelName}.show`;
  }),

  trailerId: getter(function() {
    return `${get(this, 'elementId')}-trailer`;
  }),

  actions: {
    openTrailer() {
      this.$().off('closed.zf.reveal').on('closed.zf.reveal', () => {
        set(this, 'trailerOpen', false);
      });
      set(this, 'trailerOpen', true);
    }
  }
});
