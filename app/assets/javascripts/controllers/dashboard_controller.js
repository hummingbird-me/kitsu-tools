Hummingbird.DashboardController = Ember.ArrayController.extend({
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
    postComment: function(comment) {
      var self = this;
      ic.ajax({
        url: "/stories",
        type: "POST",
        data: {
          story: {
            type: "comment",
            user_id: this.get('currentUser.id'),
            comment: comment
          }
        }
      }).then(function(response) {
        window.location.href = window.location.href;
      }, function() {
        alert("Could not submit comment.");
      });
    },

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
