Hummingbird.FavoriteAnimeContainerComponent = Em.Component.extend(Hummingbird.SortableMixin, Ember.SortableMixin,
  tagName: 'ul'
  classNames: 'media-grid'
  #TODO: Make this more efficient, sends a lot of Requests Currently. Once the editing mode is implemented, 
  # should only send after finished editing 
  updateSortOrder: (indexes)->
    list = @get("favorite_anime_list")
    _this = @

    list.forEach (item)->
      index = indexes[item.fav_id]
      Ember.set(item,'fav_rank', index)
    
    url = "/api/v1/users/" + @get('currentUser.id') + '/favorite_anime/update'
    list.forEach (item)->
      Ember.$.ajax
        url: url
        data: {id: item.fav_id, user_id: _this.get('currentUser.id'), fav_rank: item.fav_rank}
        method: 'POST'
        failure: ->
          console.log "Failed to Update Favorites Ranks"
  # JQueryUI Sortable Update method override
  update: (event, ui) ->
    indexes = {}
    thisview =  this.$()
    _this = @    

    thisview.find('.grid-thumb').each (index)->
      indexes[$(this).data('id')] = index
    _this.updateSortOrder(indexes)
)
