import Ember from 'ember';

// TODO HB.SortableMixin
export default Ember.Component.extend({
  tagName: 'ul',
  classNames: 'media-grid',
  connectWith: '.grid-thumb',
  tolerance: 'pointer',
  containment: '.favorite-anime',

  disabled: function() {
    return !this.get('isEditing');
  }.property('isEditing')
});
