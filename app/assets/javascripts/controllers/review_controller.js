HB.ReviewController = Ember.ObjectController.extend({
  positive: Em.computed.gt('rating', 2.5)
});
