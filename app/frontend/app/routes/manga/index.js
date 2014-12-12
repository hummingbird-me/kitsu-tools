import Ember from 'ember';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend({
  model: function() {
    return this.modelFor('manga');
  },

  afterModel: function(resolvedModel) {
    return setTitle(resolvedModel.get('romajiTitle'));
  }
});
