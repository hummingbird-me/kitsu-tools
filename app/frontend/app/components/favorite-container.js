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
  }.property('isEditing'),

  editable: function(){
    var self = this;

    if(this.get('isEditing')){
      this.$().dragsort({
        dragEnd: function(){
          self.$().children('li').each(function(i, fav){
            var id = $(fav).attr('data-id');
            self.get('targetObject.store').find('favorite', id).then(function(item){
              item.set('favRank', i);
            });
          })
        }
      });
    } else {
      this.$().dragsort('destroy');
    }
  }.observes('isEditing'),


  actions: {
    deleteFavorite: function(fav){
      this.get('targetObject.store').find('favorite', fav.id).then(function(item){
        item.destroyRecord();
      });
    }
  }
});
