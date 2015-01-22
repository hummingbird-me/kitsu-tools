import Ember from 'ember';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend({
  afterModel: function(resolvedModel) {
    setTitle(resolvedModel.get('name'));
  }
});
