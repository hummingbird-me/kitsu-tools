import Ember from 'ember';
import HasCurrentUser from '../mixins/has-current-user';

export default Ember.Controller.extend(HasCurrentUser, {
  needs: ['application'],

  isIndex: function() {
    return this.get('controllers.application.currentRouteName') === "apps.index";
  }.property('controllers.application.currentRouteName'),
});
