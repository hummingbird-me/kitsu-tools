HB.AppsRoute = Ember.Route.extend({
  
  model: function(){

    // The apps page only lists actively supported, community made apps.
    // Since this list is mostly static, it will be hardcoded as a model.
    return [
      {
        "name": "Tenpenchii",
        "author": [
          { "name": "Tempest", "link": "http://hummingbird.me/users/Tempest" },
        ],
        "form": "Mobile",
        "platform": "Android", 
        "screenshots": ["http://cl.ly/image/0U2x340A1A3y/tenpenchii-1.jpg", "http://cl.ly/image/3R0O0f441m0H/tenpenchii-2.jpg"],
        "desc": "Tenpenchii is a Hummingbird client for Android devices with \
              a modern user interface and amazing functionality.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/android-tenpenchii/582" },
          { "name": "Download", "link": "https://play.google.com/store/apps/details?id=com.fractalemagic" },
        ]
      },
      {
        "name": "HummingList",
        "author": [
          { "name": "Riddle", "link": "http://hummingbird.me/users/riddle" },
        ],
        "form": "Mobile",
        "platform": "iOS",
        "screenshots": ["http://cl.ly/image/2m080a251j26/humminglist-1.jpg", "http://cl.ly/image/0O391e30192u/humminglist-2.jpg"],
        "desc": "Manage your Hummingbird library on the go from your iPhone, iPad or iPod touch.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/humminglist-ios-app/17003" },
          { "name": "Download", "link": "https://itunes.apple.com/us/app/humminglist/id866713967?mt=8" },
        ]
      },
      {
        "name": "Taiga",
        "author": [
          { "name": "Erengy", "link": "http://hummingbird.me/users/Erengy" },
        ],
        "form": "Desktop",
        "platform": "Windows",
        "screenshots": ["http://cl.ly/image/1N3P0Q153Y0r/taiga-1.jpg"],
        "desc": "Taiga helps you manage your list, discover new series, share watched episodes \
              and download new ones.",
        "links": [
          { "name": "Discuss", "link": "http://forums.hummingbird.me/t/windows-taiga/10565" },
          { "name": "Download", "link": "http://taiga.erengy.com/download.php" },
        ]
      },
      {
        "name": "HAPU",
        "author": [
          { "name": "Inket", "link": "http://hummingbird.me/users/Inket" },
        ],
        "form": "Desktop",
        "platform": "Mac",
        "screenshots": ["http://cl.ly/image/2H3C0g1I2M0g/hapu-1.jpg"],
        "desc": "HAPU is a mac menubar app that allows you to interact with Hummingbird \
              and automatically update your anime progress.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/mac-hapu-scrobbler-app/56" },
          { "name": "Download", "link": "https://dl.dropboxusercontent.com/u/2439981/HAPU/Sparkle/HAPU-latest.zip" },
        ]
      },
      {
        "name": "Anitro Mobile",
        "author": [
          { "name": "Killerrin", "link": "http://hummingbird.me/users/Killerrin" },
        ],
        "form": "Mobile",
        "platform": "Windows Phone",
        "screenshots": ["http://cl.ly/image/2F2i0o1c0h27/anitro-mobile-1.jpg", "http://cl.ly/image/462c3N2f0u0F/anitro-mobile-2.jpg"],
        "desc": "Anitro is an application for Windows Phone 8.1 that allows you to View and Manage your entire profile.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/anitro-windows-8-1-windows-phone-8-1/3824" },
          { "name": "Download", "link": "http://www.windowsphone.com/en-us/store/app/anitro/6377b104-7df2-4d29-8ebb-88527728e673" },
        ]
      },
      {
        "name": "Anitro",
        "author": [
          { "name": "Killerrin", "link": "http://hummingbird.me/users/Killerrin" },
        ],
        "form": "Desktop",
        "platform": "Windows",
        "screenshots": ["http://cl.ly/image/1j113b3v1d3r/anitro-1.jpg"],
        "desc": "Anitro is an application for Windows 8.1 that allows you to View and Manage your entire profile.",
        "links": [
          { "name": "Discuss", "link": "https://forums.hummingbird.me/t/anitro-windows-8-1-windows-phone-8-1/3824" },
          { "name": "Download", "link": "http://apps.microsoft.com/windows/en-us/app/anitro/665e06bf-b4de-4cde-8ae3-c20c1a98b12b" },
        ]
      },
      {
        "name": "Zenbu",
        "author": [
          { "name": "Ippytraxx", "link": "http://hummingbird.me/users/Ippytraxx" },
        ],
        "form": "Desktop",
        "platform": "Cross Platform",
        "screenshots": ["http://cl.ly/image/2c0W3b441x38/zenbu-1.jpg"],
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
