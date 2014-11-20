HB.ModalsStoryLikesController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  likers: [],
  page: 0,
  canLoadMore: true,

  actions: {
    loadNextPage: function() {
      var self = this;
      if (!this.get('canLoadMore')) return;

      this.incrementProperty('page');

      ic.ajax({
        url: "/stories/" + this.get('id') + "/likers?page=" + this.get('page')
      }).then(function(users) {
        if (users.length < 100) {
          self.set('canLoadMore', false);
        }
        self.get('likers').pushObjects(users);
      });
    }
  }
});
