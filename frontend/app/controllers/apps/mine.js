import Ember from 'ember';
import HasCurrentUser from '../../mixins/has-current-user';
import ajax from 'ic-ajax';

export default Ember.ArrayController.extend(HasCurrentUser, {
  newAppName: '',
  actions: {
    createApp: function() {
      var self = this;
      ajax({
        url: '/apps',
        type: 'POST',
        data: {
          name: this.get('newAppName')
        }
      }).then(function() {
        self.set('newAppName', '');
        location.reload();
      });
    }
  }
});
