Hummingbird.ModalsChangelogController = Ember.ObjectController.extend Hummingbird.ModalControllerMixin,
  isLoading: true

  commits: (->
    @store.find('changelog', {order: 'date'});
  ).property('@each.changelog')