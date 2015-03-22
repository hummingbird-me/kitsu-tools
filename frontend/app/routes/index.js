import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('story', {
      landing: true
    });
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    Ember.run.scheduleOnce('afterRender', () => {
      // Offset the scroll position so that the header doesn't
      // cover the text
      Ember.$.mark.jump({
        offset: -120
      });

      let container = Ember.$('.recent-stories');
      container.masonry({
        'itemSelector': '.recent-story',
        'gutter': 10
      });

      // layout Masonry again after all images have loaded
      window.imagesLoaded(container, function() {
        container.masonry();
      });
    });
  }
});
