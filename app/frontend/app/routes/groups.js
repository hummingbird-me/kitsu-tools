import Ember from 'ember';
import Paginated from '../mixins/paginated';
import setTitle from '../utils/set-title';

export default Ember.Route.extend(Paginated, {
  beforeModel: function(transition) {
    if (!this.get('currentUser.betaAccess')) {
      return transition.abort();
    }
    setTitle('Groups');
  },

  fetchPage: function(page) {
    return this.store.find('group', {
      trending: true,
      page: page
    });
  },

  setupController: function(controller, model) {
    this.setCanLoadMore(true);
    controller.setProperties({
      'recentGroups': this.store.find('group', {}),
      'model': model
    });

    if (model.get('length') === 0) {
      this.set('cursor', null);
      this.loadNextPage();
    }
  }
});
