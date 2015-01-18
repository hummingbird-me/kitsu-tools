import Ember from 'ember';
import setTitle from '../utils/set-title';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('group', params.id);
  },

  afterModel: function(resolvedModel) {
    setTitle(resolvedModel.get('name'));
  }
});
