import Ember from 'ember';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('app', {creator: this.get('currentUser.id')});
  },

  afterModel: function() {
    return setTitle('My Applications');
  }
});
