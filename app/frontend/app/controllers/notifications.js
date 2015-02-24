import Ember from 'ember';
import ajax from 'ic-ajax';
/* global Messenger */

export default Ember.ArrayController.extend({
  init: function(){
    this.set('content', this.store.find('notification'));
    this._super();
  },

  sortProperties: ['createdAt'],
  sortAscending: false,

  unreadNotifications: Ember.computed.filterBy('content', 'seen', false),
  hasUnreadNotifications: Ember.computed.gte('unreadNotifications.length', 1),


  actions: {
    markAsRead: function(notif){
      Messenger().expectPromise(function() {
        return ajax({
          type: 'POST',
          url: '/notifications/mark_read/'+notif.get('id')
        });
      }, {
        successMessage: () => {
          notif.set('seen', true);
          return 'Marked notification as read.';
        },
        errorMessage: 'Error marking notification as read.',
        progressMessage: 'Marking notification as read...'
      });
    },

    markAllAsRead: function(){
      Messenger().expectPromise(function() {
        return ajax({
          type: 'POST',
          url: '/notifications/mark_read/'
        });
      }, {
        successMessage: () => {
          this.store.find('notification').forEach(function(notif){
            notif.set('seen', true);
          });
          return 'Marked all notifications as read.';
        },
        errorMessage: 'Error marking notifications as read.',
        progressMessage: 'Marking notifications as read...'
      });
    }
  }
});
