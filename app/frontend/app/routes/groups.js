import Ember from 'ember';
import Paginated from '../mixins/paginated';
import setTitle from '../utils/set-title';

export default Ember.Route.extend(Paginated, {
  beforeModel: function() {
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

    // only execute query if there is actually a user
    let userGroups = null;
    if (controller.get('currentUser.isSignedIn')) {
      userGroups = this.store.find('group', {
        user_id: controller.get('currentUser.id'),
        limit: 6
      });
    }

    controller.setProperties({
      'userGroups': userGroups,
      'recentGroups': this.store.find('group', { limit: 6 }),
      'model': model
    });

    if (model.get('length') === 0) {
      this.set('cursor', null);
      this.loadNextPage();
    }
  }
});
