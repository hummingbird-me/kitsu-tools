Hummingbird.ModalsChangelogController = Ember.ObjectController.extend Hummingbird.ModalControllerMixin,
  commits:( ->
    @store.find('changelog', {order: 'date'});
  ).property('@each.changelog')
