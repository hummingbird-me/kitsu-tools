import Ember from 'ember';

export default Ember.ObjectController.extend({
  isSignedIn: function() {
    return this.get('content') !== null;
  }.property('@content')
});
