import Ember from 'ember';

export default Ember.ArrayController.extend({
  init: function(){
    this.set('content', this.store.find('notification'));
    this._super();
  },

  sortProperties: ['createdAt'],
  sortAscending: false,


  actions: {
    markAsRead: function(notifId){

    },

    markAllAsRead: function(){
      
    }
  }
});
