import Ember from 'ember';
import Paginated from '../../mixins/paginated';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend(Paginated, {
  fetchPage: function(page) {
    return this.store.find('review', {
      user_id: this.modelFor('user').get('id'),
      page: page
    });
  },

  afterModel: function() {
    return setTitle(this.modelFor('user').get('username') + "'s Reviews");
  }
});
