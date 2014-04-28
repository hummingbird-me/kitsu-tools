Hummingbird.UserIndexController = Ember.ArrayController.extend
  needs: "user"
  user: Ember.computed.alias('controllers.user')
  hasWaifu: Ember.computed.any('user.waifu')
  hasLocation: Ember.computed.any('user.location')
  hasWebsite: Ember.computed.any('user.website')

  sortProperties: ['createdAt']
  sortAscending: false
  newPost: ""
  inFlight: false
  favorite_anime: []
  favorite_anime_page: 1
  isEditing: false  
  editingFavorites: false
  selectChoices: ["Waifu", "Husbando"] 
  selectedWaifu: null
 
  can_load_more:(->
    page = @get('favorite_anime_page')
    if (page*6 + 1 <= @get('favorite_anime').length)
      return true
    else return false
  ).property('favorite_anime_page', 'favorite_anime')

  favorite_anime_list: (->
    animes = @get('favorite_anime')
    page = @get('favorite_anime_page')  
  
    #if using the goPrev and goNext page style, slice the array into a chunk 
    #animes = animes.slice( (page-1)*6, page*6)

    #if using loadMoreFavorite_animes, slice the array from [0] to the page
    animes = animes.slice(0, page*6 )

    return animes 
  ).property('favorite_anime', 'favorite_anime_page')
 

  actions:
    goToEditing: ->
      @set('isEditing', true)    
    doneEditing: ->
      @get('user.content').save()
      @set('isEditing', false)
    editFav: ->
      @set('editingFavorites', true)
    doneEditingFav: ->
      @set('editingFavorites', false)
      url = "/api/v1/users/" + @get('currentUser.id') + '/favorite_anime/update'
      list = @get('favorite_anime_list')
      _this = @

      list.forEach (item)->
        Ember.$.ajax
          url: url
          data: {id: item.fav_id, user_id: _this.get('currentUser.id'), fav_rank: item.fav_rank}
          method: 'POST'
          failure: ->
            console.log "Failed to Update Favorites Ranks"
    didSelectWaifu: (character)->
      console.log(Ember.get(character, 'name')      

    loadMoreFavorite_animes: ->
      page = @get('favorite_anime_page')
      if (page*6 + 1 <= @get('favorite_anime').length)
        ++page
        @set('favorite_anime_page', page)
    
    goPrevPage: ->
      page = @get('favorite_anime_page')
      if page > 1
        --page
        @set('favorite_anime_page', page)    
    goNextPage: ->
      page = @get('favorite_anime_page')
      if( page*6 + 1 <= @get('favorite_anime').length )
        ++page 
        @set('favorite_anime_page', page)
    submitPost: (post)->
      _this = @
      newPost = @get('newPost')

      if newPost.length > 0 
        @set('inFlight', true)
        Ember.$.ajax
          url: "/users/" + _this.get('user.id') + "/comment.json"
          data: {comment: newPost}
          type: "POST"
          success: (payload)->
            stories = _this.store.find 'story', user_id: _this.get('userInfo.id')
            _this.setProperties({newPost: "", inFlight: false})
            _this.get('target').send('reloadFirstPage') 
          failure: ()->
            alert("Failed to save comment")
      else return
  lifeSpentOnAnimeFmt: (->
    minutes = @get('userInfo.lifeSpentOnAnime')

    if minutes == 0
      return "0 minutes"

    years = months = days = hours = 0
    hours = Math.floor(minutes / 60); minutes = minutes % 60
    days = Math.floor(hours / 24); hours = hours % 24
    months = Math.floor(days / 30); days = days % 30
    years = Math.floor(months / 12); months = months % 12

    str = ""
    if years > 0
      str += years + " " + (if years == 1 then "year" else "years")
    if months > 0
      if str.length > 0
        str += ", "
      str += months + " " + (if years == 1 then "month" else "months")
    if days > 0
      if str.length > 0
        str += ", "
      str += days + " " + (if days == 1 then "day" else "days")
    if hours > 0
      if str.length > 0
        str += ", "
      str += hours + " " + (if hours == 1 then "hour" else "hours")
    if minutes > 0
      if str.length > 0
        str += " and "
      str += minutes + " " + (if minutes == 1 then "minute" else "minutes")

    str

  ).property('userInfo.lifeSpentOnAnime')

  viewingSelf: (->
    @get('controllers.user.id') == @get('currentUser.id')
  ).property('model.id')
