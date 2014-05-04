Hummingbird.DashboardController = Ember.Controller.extend
  recentPost: []
  recentNews: []

  recentPostNum: 10
  recentNewsNum: 10

  recentPostPaged: (->
    @get('recentPost').slice(0, @get('recentPostNum'))
  ).property('recentPost', 'recentPostNum')
  recentNewsPaged: (->
    @get('recentNews').slice(0, @get('recentNewsNum'))
  ).property('recentNews', 'recentPostNum')

  init: ->
    $.getJSON "http://forums.hummingbird.me/latest.json", (payload) =>
      @set('recentPost', @generateThreadList(payload))

    $.getJSON "http://forums.hummingbird.me/category/industry-news/l/latest.json", (payload) =>
      @set('recentNews', @generateThreadList(payload))

  generateThreadList: (rawload) ->
    listElements = []
    listUserOrdr = {}
    for user in rawload.users
      listUserOrdr[user.id] = user

    for topic in rawload.topic_list.topics
      continue if topic.pinned
      title = topic.title
      title = topic.title[0..40]+"..." if title.length > 40
      posts = topic.highest_post_number
      udate = topic.last_posted_at
      link  = "http://forums.hummingbird.me/t/"+topic.slug+"/"+topic.id+"/"
      users = []
      for user in topic.posters
        thisName = listUserOrdr[user.user_id]['username']
        users.push
          link:  "http://forums.hummingbird.me/users/"+thisName+"/activity"
          name:  thisName
          image: listUserOrdr[user.user_id]['avatar_template'].replace("{size}", "thumb")
          title: user.description

      listElements.push
        title: title
        posts: posts
        users: users
        udate: udate
        link:  link

    listElements

  actions: 
    showMorePost: ->
      @set('recentPostNum', @get('recentPostNum')+10) if @get('recentPostNum') < 30
    showMoreNews: ->
      @set('recentNewsNum', @get('recentNewsNum')+10) if @get('recentNewsNum') < 30