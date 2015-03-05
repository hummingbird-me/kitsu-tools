import Ember from 'ember';
import Paginated from '../../mixins/paginated';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend(Paginated, {
  fetchPage: function(page) {
    return this.store.find('group-member', {
      group_id: this.modelFor('group').get('id'),
      page: page
    });
  },

  afterModel: function() {
    setTitle(this.modelFor('group').get('name') + "'s Members");
  }
});
