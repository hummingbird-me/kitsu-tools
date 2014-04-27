Hummingbird.FavoriteAnimeContainerComponent = Em.Component.extend(Hummingbird.SortableMixin, Ember.SortableMixin,
  tagName: 'ul'
  classNames: 'media-grid'
  #TODO: Make this more efficient, sends a lot of Requests Currently. Once the editing mode is implemented, 
  # should only send after finished editing 
  disabled:(->
    return !@get('isEditing')
  ).property('isEditing') 
 
  connectWith: ->
    this.$().find('.grid-thumb')
 
  updateSortOrder: (indexes)->
    list = @get("favorite_anime_list")
    _this = @

    list.forEach (item)->
      index = indexes[item.fav_id]
      Ember.set(item,'fav_rank', index)
    
  # JQueryUI Sortable Update method override
  update: (event, ui) ->
    indexes = {}
    thisview =  this.$()
    _this = @    

    thisview.find('.grid-thumb').each (index)->
      indexes[$(this).data('id')] = index
    _this.updateSortOrder(indexes)
)
