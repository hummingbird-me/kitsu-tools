import Ember from 'ember';
import HasCurrentUser from '../../mixins/has-current-user';

export default Ember.Controller.extend(HasCurrentUser, {
  allMembers: function() {
    // remove the current users record from the data if
    // they are still in the pending state
    var arr = this.get('model');
    var record = arr.findBy('user.id', this.get('currentUser.id'));
    if (record && record.get('pending') === true) {
      arr = arr.without(record);
    }
    return arr;
  }.property('model.@each')
});
