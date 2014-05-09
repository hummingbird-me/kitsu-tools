Hummingbird.DashboardController = Ember.Controller.extend
  recentPost: []
  recentNews: []
  recentPostNum: 5
  recentNewsNum: 5
  newPost: ""
  inFlight: false

  recentPostMax: (->
    @get('recentPostNum') == 29
  ).property('recentPostNum')
  recentNewsMax: (->
    @get('recentNewsNum') == 29
  ).property('recentNewsNum')

  recentPostPaged: (->
    @get('recentPost').slice(0, @get('recentPostNum'))
  ).property('recentPost', 'recentPostNum')
  recentNewsPaged: (->
    @get('recentNews').slice(0, @get('recentNewsNum'))
  ).property('recentNews', 'recentNewsNum')

  init: ->
    @send("setupQuickUpdate")
    $.getJSON "http://forums.hummingbird.me/latest.json", (payload) =>
      @set('recentPost', @generateThreadList(payload))

    $.getJSON "http://forums.hummingbird.me/category/industry-news.json", (payload) =>
      @set('recentNews', @generateThreadList(payload))
 
  generateThreadList: (rawload) ->
    listElements = []
    listUserOrdr = {}
    for user in rawload.users
      listUserOrdr[user.id] = user

    for topic in rawload.topic_list.topics
      continue if topic.pinned
      title = topic.title
      posts = topic.highest_post_number
      udate = topic.last_posted_at
      link  = "http://forums.hummingbird.me/t/"+topic.slug+"/"+topic.id+"/"
      users = []
      for user in topic.posters
        thisName = listUserOrdr[user.user_id]['username']
        users.push
          link:  "http://forums.hummingbird.me/users/"+thisName+"/activity"
          name:  thisName
          image: listUserOrdr[user.user_id]['avatar_template'].replace("{size}", "small").replace(".gif?", ".jpg?")
          title: user.description

      listElements.push
        title: title
        posts: posts
        users: users
        udate: udate
        link:  link

    listElements
  mutableUsersToFollow: []
  usersToFollowChanged: (->
    mutable = []
    usersToFollow  = @get('usersToFollow')
    if usersToFollow.isFulfilled
      usersToFollow.forEach( (user)->
        mutable.addObject(user)
        return
      )
    this.set('mutableUsersToFollow', mutable)
  ).observes('usersToFollow', 'usersToFollow.isFulfilled', 'usersToFollow.length')
  newUsersToLoad: []
  newUserObserver: (->
    mutable = @get('mutableUsersToFollow')
    newUsers = @get('newUsersToLoad')
    if newUsers and newUsers.isFulfilled  
      newUsers.forEach((user)->
        mutable.pushObject(user)
        return
      )
  ).observes('newUsersToLoad', 'newUsersToLoad.isFulfilled', 'newUsersToLoad.length')
  actions:
    dismiss: (user)->
      mutable = @get('mutableUsersToFollow')
      mutable.removeObject(user)
    loadMoreToFollow: ->
      newusers = @store.find 'user', followlist: true, user_id: @get('currentUser.id')
      @set('newUsersToLoad', null)
      @set('newUsersToLoad', newusers)
    showMorePost: ->
      if @get('recentPostMax')
        window.location.replace("http://forums.hummingbird.me/latest");
      else
        @set('recentPostNum', @get('recentPostNum')+8)
      
    showMoreNews: ->
      if @get('recentNewsMax')
        window.location.replace("http://forums.hummingbird.me/category/industry-news");
      else
        @set('recentNewsNum', @get('recentNewsNum')+8)
    submitPost: (post)->
      _this = @
      newPost = @get('newPost')

      if newPost.length > 0 
        @set('inFlight', true)
        Ember.$.ajax
          url: "/users/" + _this.get('currentUser.id') + "/comment.json"
          data: {comment: newPost}
          type: "POST"
          success: (payload)->
            _this.setProperties({newPost: "", inFlight: false})
            _this.get('target').send('checkForAndAddNewObjects') 
          failure: ()->
            alert("Failed to save comment")
      else return
