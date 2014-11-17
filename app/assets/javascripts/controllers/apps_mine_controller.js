HB.AppsMineController = Ember.ArrayController.extend(HB.HasCurrentUser, {
  newAppName: '',
  actions: {
    createApp: function() {
      var self = this;
      ic.ajax({
        url: '/apps',
        type: 'POST',
        data: {
          name: this.get('newAppName')
        }
      }).then(function(payload) {
        self.set('newAppName', '');
        location.reload();
      });
    }
  }
});
