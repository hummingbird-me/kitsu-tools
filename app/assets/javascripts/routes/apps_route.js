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
              a modern user interface and amazing functionality.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/android-tenpenchii/582" },
          { "name": "Download", "link": "https://play.google.com/store/apps/details?id=com.fractalemagic" },
        ]
      },
      {
        "name": "Taiga",
        "type": "Windows",
        "cover": "",
        "desc": "Taiga helps you manage your list, discover new series, share watched episodes \
              and download new ones.",
        "links": [
          { "name": "Discuss", "link": "http://forums.hummingbird.me/t/windows-taiga/10565" },
          { "name": "Download", "link": "http://taiga.erengy.com/download.php" },
        ]
      },
      {
        "name": "HAPU",
        "type": "Mac",
        "cover": "",
        "desc": "HAPU is a mac menubar app that allows you to interact with Hummingbird \
              and automatically update your anime progress.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/mac-hapu-scrobbler-app/56" },
          { "name": "Download", "link": "https://dl.dropboxusercontent.com/u/2439981/HAPU/Sparkle/HAPU-latest.zip" },
        ]
      },
      {
        "name": "Anitro Mobile",
        "type": "Windows Phone",
        "cover": "",
        "desc": "Anitro is an application for Windows Phone 8.1 that allows you to View and Manage your entire profile.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/anitro-windows-8-1-windows-phone-8-1/3824" },
          { "name": "Download", "link": "http://www.windowsphone.com/en-us/store/app/anitro/6377b104-7df2-4d29-8ebb-88527728e673" },
        ]
      },
       {
        "name": "Anitro",
        "type": "Windows ",
        "cover": "",
        "desc": "Anitro is an application for Windows 8.1 that allows you to View and Manage your entire profile.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/anitro-windows-8-1-windows-phone-8-1/3824" },
          { "name": "Download", "link": "http://apps.microsoft.com/windows/en-us/app/anitro/665e06bf-b4de-4cde-8ae3-c20c1a98b12b" },
        ]
      },
      {
        "name": "Zenbu",
        "type": "Cross Platform",
        "cover": "",
        "desc": "Zenbu is a cross-platform, multi functional, anime and manga desktop \
              management application with exceptional features.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/zenbu-development-log-new-installer-in-development/1583" },
          { "name": "Download", "link": "https://bitbucket.org/Ippytraxx/zenbu/downloads" },
        ]
      }
    ]

  }

});
