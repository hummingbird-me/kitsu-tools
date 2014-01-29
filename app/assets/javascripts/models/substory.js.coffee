Hummingbird.Substory = DS.Model.extend
  type: DS.attr('string')
  createdAt: DS.attr('date')
  newStatus: DS.attr('string')
  episodeNumber: DS.attr('number')

  html: (->
    if @get('type') == "watchlist_status_update"
      {
        "Plan to Watch": " plans to watch."
        "Currently Watching": " is currently watching."
        "Completed": " has completed."
        "On Hold": " has placed on hold."
        "Dropped": " has dropped."
      }[@get('newStatus')]
    else if @get('type') == "watched_episode"
      " watched episode " + @get('episodeNumber') + "."
    else
      "&lt;unknown type encountered:" + @get('type') + ">"
  ).property('type', 'newStatus', 'episodeNumber')
