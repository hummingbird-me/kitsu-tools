/* global Masonry */

import Ember from 'ember';
import jQuery from 'jquery';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('story', {
      landing: true
    });
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    Ember.run.scheduleOnce('afterRender', () => {
      jQuery.mark.jump({
        offset: -120
      });
      var msnry = new Masonry( '.recent-stories', {
        // options
        "itemSelector": '.recent-story',
        "gutter": 10
      });
      // layout Masonry again after all images have loaded
      imagesLoaded( container, function() {
        msnry.layout();
      });
    });
  }
});