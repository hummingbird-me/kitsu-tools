import Ember from 'ember';
import HasCurrentUser from '../../mixins/has-current-user';

export default Ember.Controller.extend(HasCurrentUser, {
  userList: function (){
    return this.store.all('user');
  }.property('loading')
});
