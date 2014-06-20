Hummingbird.ApplicationRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    var headerController = this.controllerFor("header");
    return headerController.set("notifications", this.store.find('notification'));
  },

  actions: {
    setupQuickUpdate: function() {
      var headerController = this.controllerFor("header");
      if (this.get('currentUser.isSignedIn')) {
        return headerController.set('recentLibraryEntries', this.store.find('library_entry', {
          user_id: this.get('currentUser.id'),
          recent: true
        }));
      } else {
        return headerController.set('recentLibraryEntries', []);
      }
    },

    toggleFollow: function(user) {
      if (!this.get('currentUser.isSignedIn')) {
        alert("Need to be signed in!");
        return;
      }

      var originalState = user.get('isFollowed');
      user.set('isFollowed', !originalState);
      return ic.ajax({
        url: "/users/" + user.get('id') + "/follow",
        type: "POST",
        dataType: "json"
      }).then(Ember.K, function() {
        alert("Something went wrong.");
        return user.set('isFollowed', originalState);
      });
    },

    openModal: function(modalName, model) {
      this.controllerFor("modals." + modalName).set('content', model);
      return this.render("modals/" + modalName, {
        outlet: 'modal',
        into: 'application'
      });
    },
    
    closeModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    }
  }
});