import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'a',

  initializeTooltip: function() {
    return this.$().tooltip({
      placement: this.get('placement'),
      title: this.get('title')
    });
  }.on('didInsertElement'),

  updateTooltip: function() {
    this.$().tooltip('destroy');
    return this.initializeTooltip();
  }.observes('title', 'placement')
});
