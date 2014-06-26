Hummingbird.FavoriteAnimeContainerComponent = Em.Component.extend(Hummingbird.SortableMixin, Ember.SortableMixin, {
  tagName: 'ul',
  classNames: 'media-grid',
  connectWith: '.grid-thumb',
  tolerance: 'pointer',
  containment: '.favorite-anime',


  disabled: function() {
    return !this.get('isEditing');
  }.property('isEditing'),

  updateSortOrder: function(indexes) {
    var list = this.get("favorite_anime_list"),
        _this = this;
    return list.forEach(function(item) {
      var index = indexes[item.fav_id];
      return Ember.set(item, 'fav_rank', index);
    });
  },

  update: function(event, ui) {
    var indexes = {},
        _this = this;
    this.$().find('.grid-thumb').each(function(index) {
      return indexes[$(this).data('id')] = index;
    });
    return _this.updateSortOrder(indexes);
  }
});
