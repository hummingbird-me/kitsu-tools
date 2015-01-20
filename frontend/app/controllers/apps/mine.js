import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.ArrayController.extend({
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
