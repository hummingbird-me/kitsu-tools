import Ember from 'ember';

export default Ember.ArrayController.extend({
  init: function(){
    //FIXME this.set('content', this.store.find('notification'));
    this._super();
  },

  sortProperties: ['createdAt'],
  sortAscending: false
});
