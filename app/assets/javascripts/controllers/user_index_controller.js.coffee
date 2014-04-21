Hummingbird.UserIndexController = Ember.ArrayController.extend
  needs: "user"
  user: Ember.computed.alias('controllers.user')

  sortProperties: ['createdAt']
  sortAscending: false
  newPost: ""
  inFlight: false

  actions:
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
            _this.setProperties({'content': stories, newPost: "", inFlight: false})
            
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
