Hummingbird.CurrentUserController = Ember.ObjectController.extend({
  isSignedIn: function () {
    return this.get('content') != null;
  }.property('@content'),

  isAdmin: function () {
    return ["vikhyat", "Josh", "ryn", "Saijin", "Cairus"].contains(this.get('content.username'));
  }.property('@content.username')
});
