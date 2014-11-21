HB.ModalsStoryLikesController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  likers: [],
  page: 0,
  canLoadMore: true,

  // Ember controller is a singleton, and we don't have a route associated
  // with this modal, so reset properties when the model changes.
  resetModal: function() {
    this.setProperties({
      likers: [],
      page: 0,
      canLoadMore: true
    });
  }.observes('model'),

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
