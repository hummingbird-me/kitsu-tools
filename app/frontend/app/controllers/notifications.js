import Ember from 'ember';

export default Ember.ArrayController.extend({
  init: function(){
    this.set('content', this.store.find('notification'));
    this._super();
  },

  sortProperties: ['createdAt'],
  sortAscending: false,


  actions: {
    markAsRead: function(notif){
      Messenger().run({
        action: $.ajax,

        successMessage: () => {
          notif.set('seen', true);
          return 'Marked notification as read.';
        },
        errorMessage: 'Error marking notification as read.',
        progressMessage: 'Marking notification as read...'
      }, {
        url: '/notifications/mark_read/'+notif.get('id')
      });
    },

    markAllAsRead: function(){
      Messenger().run({
        action: $.ajax,

        successMessage: () => {
          this.store.find('notification').forEach(function(notif){
            notif.set('seen', true);
          });
          return 'Marked all notifications as read.';
        },
        errorMessage: 'Error marking notifications as read.',
        progressMessage: 'Marking notifications as read...'
      }, {
        url: '/notifications/mark_read'
      });
    }
  }
});
