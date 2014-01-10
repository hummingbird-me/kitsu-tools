Hummingbird.Anime = DS.Model.extend
  canonicalTitle: DS.attr('string')
  synopsis: DS.attr('string')
  posterImage: DS.attr('string')
  genres: DS.attr('array')
  showType: DS.attr('string')
  ageRating: DS.attr('string')
  ageRatingGuide: DS.attr('string')
  episodeCount: DS.attr('number')
  episodeLength: DS.attr('number')
  startedAiring: DS.attr('date')
  startedAiringDateKnown: DS.attr('boolean')
  finishedAiring: DS.attr('date')

  libraryEntry: DS.belongsTo('libraryEntry')

  displayEpisodeCount: (->
    e = @get('episodeCount')
    if e
      e
    else
      "?"
  ).property('episodeCount')

  airingStatus: (->
    unless @get('startedAiring')
      return "Not Yet Aired"

    now = Date.now()

    if @get('startedAiring') > now
      return "Not Yet Aired"

    if @get('episodeCount') == 1
      return "Finished Airing"

    if @get('finishedAiring') and @get('finishedAiring') < now
      return "Finished Airing"
    else
      return "Currently Airing"
  ).property('startedAiring', 'finishedAiring', 'episodeCount')

  notYetAired: Ember.computed.equal('airingStatus', 'Not Yet Aired')

  formattedAirDates: (->
    if @get('startedAiring')
      format = if @get('startedAiringDateKnown') then "D MMM YYYY" else "MMM YYYY"
      formattedStartedAiring = moment(@get('startedAiring')).utc().format(format)
    else
      formattedStartedAiring = "?"

    if @get('finishedAiring')
      formattedFinishedAiring = moment(@get('finishedAiring')).utc().format("D MMM YYYY")
    else
      formattedFinishedAiring = "?"

    if @get('airingStatus') == "Finished Airing"
      result = "Aired"
    else if @get('airingStatus') == "Currently Airing"
      result = "Airing"
    else
      result = "Will air"

    if (@get('episodeCount') and @get('episodeCount') == 1) or @get('startedAiring') == @get('finishedAiring')
      result += " on " + formattedStartedAiring
    else
      result += " from " + formattedStartedAiring
      if formattedFinishedAiring != "?"
        result += " to " + formattedFinishedAiring

    result
  ).property('startedAiring', 'finishedAiring')

