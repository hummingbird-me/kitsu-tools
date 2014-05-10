Hummingbird.UserIndexController = Ember.ArrayController.extend
  needs: "user"
  user: Ember.computed.alias('controllers.user')
  waifu_slug: (->
     waifu_slug = @get('user.waifuSlug')
     return "/anime/" + waifu_slug
  ).property('user.waifuSlug')
  hasWaifu: Ember.computed.any('user.waifu')
  hasLocation: Ember.computed.any('user.location')
  hasWebsite: Ember.computed.any('user.website')
  unselectingWaifu: false

  bioCharsLeft: (->
    @get('bioCharCounter') != 0
  ).property('bioCharCounter')
  bioCharCounter: (->
    newString = @get('user.miniBio')
    newString = "" if(newString == null || newString == undefined)
    newLength = newString.length
    remLength = 160 - newLength
    if remLength <= 0
      @set('user.miniBio', newString[0...160])
      remLength = 0
    remLength
  ).property('user.miniBio')

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
    unselectWaifu: ->
      @set('unselectingWaifu', true)
      @set('user.waifu', null)
    goToEditing: ->
      @set('isEditing', true)    
    doneEditing: ->
      @set('unselectingWaifu', false)
      @get('user.content').save()
      @set('isEditing', false)
    editFav: ->
      @set('editingFavorites', true)
    doneEditingFav: ->
      @set('editingFavorites', false)
      url = "/api/v1/users/" + @get('currentUser.id') + '/favorite_anime/update'
      list = @get('favorite_anime_list')
      _this = @
      data = {} 

      list.forEach (item)->
        data[item.fav_id]={id: item.fav_id, user_id: _this.get('currentUser.id'), fav_rank: item.fav_rank}

      Ember.$.ajax
        url: url
        data: {data:data}
        method: 'POST'
        failure: ->
          console.log "Failed to Update Favorites Ranks"


    didSelectWaifu: (character)->
      @set('selectedWaifu', character)
      @get('user').set('waifu', character.value)
      @get('user').set('waifuCharId', character.char_id)
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
            _this.get('target').send('checkForAndAddNewObjects') 
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
      str += months + " " + (if months == 1 then "month" else "months")
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
