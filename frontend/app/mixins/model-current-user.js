import Ember from 'ember';

export default Ember.Mixin.create({
  currentUser: function() {
    // HACK! since we can't inject current-user into models.
    return this.container.lookup('controller:current-user');
  }.property()
});
