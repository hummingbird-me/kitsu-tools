Hummingbird.ModalsChangelogController = Ember.ObjectController.extend(Hummingbird.ModalControllerMixin, {
  isLoading: true,
  commits: function () {
    return this.store.find('changelog', {
      order: 'date'
    });
  }.property('@each.changelog')
});
