import Ember from 'ember';

export default Ember.ObjectProxy.extend({
  isSignedIn: function() {
    return this.get('content') !== null;
  }.property('@content')
});
