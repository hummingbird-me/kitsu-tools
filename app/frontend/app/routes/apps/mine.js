import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('app', {creator: this.get('currentUser.id')});
  }
});
