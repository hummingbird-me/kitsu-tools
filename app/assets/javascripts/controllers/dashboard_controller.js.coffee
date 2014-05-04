Hummingbird.DashboardController = Ember.Controller.extend
  recentPost: []
  recentNews: []

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
      posts = topic.posts_count
      link  = "http://forums.hummingbird.me/t/"+topic.slug+"/"+topic.id+"/"
      users = []
      for user in topic.posters
        thisName = listUserOrdr[user.user_id]['name']
        users.push
          link:  "http://forums.hummingbird.me/users/"+thisName+"/activity"
          name:  thisName
          image: listUserOrdr[user.user_id]['avatar_template'].replace("{size}", "small")
          title: user.description

      listElements.push
        title: title
        posts: posts
        users: users
        link:  link

    listElements