import Ember from 'ember';

// TODO HB.SortableMixin
export default Ember.Component.extend({
  tagName: 'ul',
  classNames: 'media-grid',
  connectWith: '.grid-thumb',
  tolerance: 'pointer',
  containment: '.favorite-anime',

  favoriteList: function(){
    return this.get('favorites').sortBy('favRank');
  }.property('favorites' ,'isEditing'),

  disabled: function() {
    return !this.get('isEditing');
  }.property('isEditing'),

  editable: function(){
    var self = this;

    if(this.get('isEditing')){
      this.$().dragsort({
        dragSelector: ".grid-draggable",
        dragEnd: function(){
          self.$().children('li').each(function(i, fav){
            var id = self.$(fav).attr('data-id');
            self.get('targetObject.store').find('favorite', id).then(function(item){
              item.set('favRank', i);
            });
          });
        }
      });
    } else {
      // Manual workaround for broken part in vendor script
      // this.$().dragsort('destroy');
      this.$().unbind("mousedown")
              .children().unbind("mousedown")
                         .unbind("dragsort-uninit");
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
