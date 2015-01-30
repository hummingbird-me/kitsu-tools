import Ember from 'ember';
import Paginated from '../../mixins/paginated';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend(Paginated, {
  // use the recent members data we already have
  model: function() {
    // keep `cursor` at 1, as first visit we only have at most 15 members
    // and pages are per 20.
    return this.store.filter('group-member', (member) => {
      return member.get('groupId') === this.modelFor('group').get('id');
    });
  },

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
