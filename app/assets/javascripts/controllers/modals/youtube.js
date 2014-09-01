Hummingbird.ModalsYoutubeController = Ember.ObjectController.extend(Hummingbird.ModalControllerMixin, {
  youtubeEmbedURL: function () {
    return "https://www.youtube.com/embed/" + this.get('youtubeVideoId');
  }.property('youtubeVideoId')
});
