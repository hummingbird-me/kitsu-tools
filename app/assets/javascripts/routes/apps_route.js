HB.AppsRoute = Ember.Route.extend({
  
  model: function(){

    // The apps page only lists actively supported, community made apps.
    // Since this list is mostly static, it will be hardcoded as a model.
    return [
      {
        "name": "Tenpenchii",
        "type": "Android",
        "cover": "",
        "desc": "Tenpenchii is a Hummingbird client for Android devices with \
              a modern user interface and amazing functionality. It has been \
              around for over a year now and slowly emerged to the inofficial \
              Hummingbird client for Android.",
        "links": [
          { "name": "Website", "link": "http://fractalemagic.com/" },
          { "name": "Thread", "link": "https://forums.hummingbird.me/t/android-tenpenchii/582" },
        ]
      },
      {
        "name": "Taiga",
        "type": "Windows",
        "cover": "",
        "desc": "Taiga is an open source, lightweight, anime tracker for Windows. \
              It can automatically detect the episodes you're watching on your \
              computer and synchronize your progress with Hummingbird. It helps \
              you manage your list, discover new series, share watched episodes \
              and download new ones.",
        "links": [
          { "name": "Website", "link": "http://taiga.erengy.com" },
          { "name": "Source", "link": "http://taiga.erengy.com"},
          { "name": "Thread", "link": "http://forums.hummingbird.me/t/windows-taiga/10565" },
        ]
      },
      {
        "name": "HAPU",
        "type": "Mac",
        "cover": "",
        "desc": "HAPU is a menubar app that allows you to interact with Hummingbird \
              and automatically update your anime progress, this also includes posting \
              to your acticity feed, getting notifications on comment replies, serch for \
              anime directly withing the app and share what you're watching directly via \
              facebook or twitter.",
        "links": [
          { "name": "Website", "link": "http://mahdi.jp/apps/hapu" },
          { "name": "Thread", "link": "https://forums.hummingbird.me/t/mac-hapu-scrobbler-app/56" },
        ]
      },
      {
        "name": "Anitro",
        "type": "Windows /- Phone",
        "cover": "",
        "desc": "Anitro is an Anime management application for Windows Phone 8.1 and Windows \
            8.1 which utilizes the Hummingbird service, and will allow you to View and Manage \
            your entire profile.",
        "links": [
          { "name": "Windows Phone Store", "link": "http://www.windowsphone.com/en-us/store/app/anitro/6377b104-7df2-4d29-8ebb-88527728e673" },
          { "name": "Windows Store", "link": "http://apps.microsoft.com/windows/en-us/app/anitro/665e06bf-b4de-4cde-8ae3-c20c1a98b12b" },
          { "name": "Thread", "link": "https://forums.hummingbird.me/t/anitro-windows-8-1-windows-phone-8-1/3824" },
        ]
      },
      {
        "name": "Zenbu",
        "type": "Cross Platform",
        "cover": "",
        "desc": "Zenbu is a cross-platform, multi functional, anime and manga desktop \
              management application with exceptional features.",
        "links": [
          { "name": "Info and Source", "link": "https://bitbucket.org/Ippytraxx/zenbu" },
          { "name": "Thread", "link": "https://forums.hummingbird.me/t/zenbu-development-log-new-installer-in-development/1583" },
        ]
      }
    ]

  }

});
