Hummingbird.CurrentUserController = Ember.ObjectController.extend
  isSignedIn: (->
    @get('content') != null
  ).property('@content')

  isAdmin: (->
    ["vikhyat", "Josh", "ryn", "Saijin", "Tavor", "Cairus"].contains @get('content.username')
  ).property('@content.username')
