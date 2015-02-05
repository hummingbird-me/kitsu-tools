import Ember from 'ember';
import Paginated from '../../mixins/paginated';

export default Ember.Route.extend(Paginated, {
  fetchPage: function(page) {
    return this.store.find('group', {
      user_id: this.modelFor('user').get('id'),
      page: page
    });
  }
});
