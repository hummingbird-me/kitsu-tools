Hummingbird.ModalsYoutubeController = Ember.ObjectController.extend Hummingbird.ModalControllerMixin,
  youtubeEmbedURL: (->
    "http://www.youtube.com/embed/" + @get('youtubeVideoId')
  ).property('youtubeVideoId')
