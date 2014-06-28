Hummingbird.HasCurrentUser = Ember.Mixin.create({
  needs: ['currentUser'],
  currentUser: Em.computed.alias('controllers.currentUser')
});
