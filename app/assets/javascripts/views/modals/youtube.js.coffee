Hummingbird.YoutubeModalView = Hummingbird.ModalView.extend
  templateName: "modals/youtube"

  youtubeEmbedURL: (->
    "http://www.youtube.com/embed/" + @get('controller.youtubeVideoId')
  ).property('controller.youtubeVideoId')
