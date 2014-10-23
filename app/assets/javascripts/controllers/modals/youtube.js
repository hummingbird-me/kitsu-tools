HB.ModalsYoutubeController = Ember.ObjectController.extend(HB.ModalControllerMixin, {
  youtubeEmbedURL: function () {
    return "https://www.youtube.com/embed/" + this.get('youtubeVideoId');
  }.property('youtubeVideoId')
});
