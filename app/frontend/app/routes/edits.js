import Ember from 'ember';
import Paginated from '../mixins/paginated';
import setTitle from '../utils/set-title';

export default Ember.Route.extend(Paginated, {
  preloadKey: "versions",
  preloadPath: "versions",
  preloadObject: "version",

  fetchPage: function(page) {
    return this.store.find('version', {
      state: 'pending',
      page: page
    });
  },

  afterModel: function() {
    setTitle('Pending Edits');
  },

  setupController: function(controller, model) {
    this.setCanLoadMore(true);
    controller.set('model', model);
    if (model.get('length') === 0) {
      this.set('cursor', null);
      this.loadNextPage();
    }
  }
});
