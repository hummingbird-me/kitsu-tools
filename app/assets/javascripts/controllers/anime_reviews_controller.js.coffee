Hummingbird.AnimeReviewsController = Ember.ArrayController.extend
  needs: "anime"
  anime: Ember.computed.alias('controllers.anime')
  sortProperties: ['wilsonScore']
  sortAscending: false
