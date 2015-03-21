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

      var container = Ember.$('.recent-stories');
      container.masonry({
        "itemSelector": '.recent-story',
        "gutter": 10
      });

      // layout Masonry again after all images have loaded
      window.imagesLoaded(container, function() {
        container.masonry();
      });
    });
  }
});