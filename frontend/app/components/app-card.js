import Ember from 'ember';

export default Ember.Component.extend({
  classNames: 'block-grid-item',
  app: null,
  showSecret: false,

  isOwner: function() {
    return this.get('app.creator.id') === this.get('currentUser.id');
  }.property('app.creator', 'currentUser'),

  actions: {
    toggleSecret: function(value) {
      value = (value === undefined) ? !this.get('showSecret') : value;
      this.set('showSecret', value);
    }
  }
});
