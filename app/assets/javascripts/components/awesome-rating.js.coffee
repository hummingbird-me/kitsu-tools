Hummingbird.AwesomeRatingComponent = Ember.Component.extend
  editable: false
  type: "advanced"
  rating: null
  classNames: ["awesome-rating-widget"]

  applyAwesomeRating: (->
    that = this
    @$().AwesomeRating
      rating: @get('rating')
      type: @get('type')
      editable: @get('editable')
      update: (newRating) ->
        alert "Not implemented yet -- coming soon!"
        that.set 'rating', newRating
  ).on('didInsertElement').observes('rating')
