HB.NotificationsController = Ember.ArrayController.extend({

  init: function(){
    var self = this;
    this.set('content', self.store.find('notification'));
    this._super();
  },

  sortProperties: ['createdAt'],
  sortAscending: false
});
