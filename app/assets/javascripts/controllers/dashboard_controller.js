Hummingbird.DashboardController = Ember.Controller.extend({
  recentPost: [],
  recentNews: [],
  recentPostNum: 5,
  recentNewsNum: 5,
  newPost: "",
  inFlight: false,

  recentPostMax: function () {
    return this.get('recentPostNum') === 29;
  }.property('recentPostNum'),
  recentNewsMax: function () {
    return this.get('recentNewsNum') === 29;
  }.property('recentNewsNum'),

  recentPostPaged: function () {
    return this.get('recentPost').slice(0, this.get('recentPostNum'));
  }.property('recentPost', 'recentPostNum'),
  recentNewsPaged: function () {
    return this.get('recentNews').slice(0, this.get('recentNewsNum'));
  }.property('recentNews', 'recentNewsNum'),

  init: function () {
    var _this = this;
    this.send("setupQuickUpdate");
    $.getJSON("http://forums.hummingbird.me/latest.json", function (payload) {
      return _this.set('recentPost', _this.generateThreadList(payload));
    });
    $.getJSON("http://forums.hummingbird.me/category/industry-news.json", function (payload) {
      return _this.set('recentNews', _this.generateThreadList(payload));
    });
  },

  generateThreadList: function (rawload) {
    var listElements = [];
    var listUserOrdr = {};
    for (var i = 0, l = rawload.users.length; i < l; i++) {
      var user = rawload.users[i];
      listUserOrdr[user.id] = user;
    }

    for (i = 0, l = rawload.topic_list.topics.length; i < l; i++) {
      var topic = rawload.topic_list.topics[i];
      if (topic.pinned) continue;

      var title = topic.title
        , posts = topic.highest_post_number
        , udate = topic.last_posted_at
        , link = "http://forums.hummingbird.me/t/" + topic.slug + "/" + topic.id + "/"
        , users = [];

      for (var ii = 0, ll = topic.posters.length; ii < ll; ll++) {
        var user = topic.posters[j]
          , thisName = listUserOrdr[user.user_id].username;
        users.push({
          link: "http://forums.hummingbird.me/users/" + thisName + "/activity",
          name: thisName,
          image: listUserOrdr[user.user_id]['avatar_template'].replace("{size}", "small").replace(/\.[a-zA-Z]+\?/, '.jpg?'),
          title: user.description
        });
      }
      listElements.push({
        title: title,
        posts: posts,
        users: users,
        udate: udate,
        link: link
      });
    }
    return listElements;
  },
  mutableUsersToFollow: [],
  usersToFollowChanged: (function () {
    var mutable = []
      , usersToFollow = this.get('usersToFollow');

    if (usersToFollow.isFulfilled) {
      usersToFollow.forEach(function (user) {
        mutable.addObject(user);
      });
    }
    return this.set('mutableUsersToFollow', mutable);
  }).observes('usersToFollow', 'usersToFollow.isFulfilled', 'usersToFollow.length'),
  newUsersToLoad: [],
  newUserObserver: function () {
    var mutable = this.get('mutableUsersToFollow')
      , newUsers = this.get('newUsersToLoad');

    if (newUsers && newUsers.isFulfilled) {
      return newUsers.forEach(function (user) {
        mutable.pushObject(user);
      });
    }
  }.observes('newUsersToLoad', 'newUsersToLoad.isFulfilled', 'newUsersToLoad.length'),
  actions: {
    dismiss: function (user) {
      var mutable = this.get('mutableUsersToFollow');
      return mutable.removeObject(user);
    },
    loadMoreToFollow: function () {
      var newusers = this.store.find('user', {
        followlist: true,
        user_id: this.get('currentUser.id')
      });
      this.set('newUsersToLoad', null);
      return this.set('newUsersToLoad', newusers);
    },
    showMorePost: function () {
      if (this.get('recentPostMax')) {
        return window.location.replace("http://forums.hummingbird.me/latest");
      } else {
        return this.set('recentPostNum', this.get('recentPostNum') + 8);
      }
    },

    showMoreNews: function () {
      if (this.get('recentNewsMax')) {
        return window.location.replace("http://forums.hummingbird.me/category/industry-news");
      } else {
        return this.set('recentNewsNum', this.get('recentNewsNum') + 8);
      }
    },

    // FIXME This is _broken_.
    submitPost: function (post) {
      var _this = this
        , newPost = this.get('newPost');

      if (newPost.length > 0) {
        this.set('inFlight', true);
        return Ember.$.ajax({
          url: "/users/" + _this.get('currentUser.id') + "/comment.json",
          data: { comment: newPost },
          type: "POST",
          success: function (payload) {
            _this.setProperties({
              newPost: "",
              inFlight: false
            });
            window.location.href = window.location.href;
          },
          failure: function () {
            return alert("Failed to save comment");
          }
        });
      }
    }
  }
});
