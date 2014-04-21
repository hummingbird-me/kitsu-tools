Hummingbird.CurrentUserController = Ember.ObjectController.extend
  isSignedIn: (->
    @get('content') != null
  ).property('@content')

  isAdmin: (->
    ["vikhyat", "Josh", "ryn", "Saijin", "Cairus"].contains @get('content.username')
  ).property('@content.username')
