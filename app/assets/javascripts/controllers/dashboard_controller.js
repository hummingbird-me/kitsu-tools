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
    }
  }
});
