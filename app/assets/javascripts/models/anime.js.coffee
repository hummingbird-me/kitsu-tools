Hummingbird.Anime = DS.Model.extend
  canonicalTitle: DS.attr('string')
  synopsis: DS.attr('string')
  posterImage: DS.attr('string')
  genres: DS.attr('array')
  languages: DS.attr('array')
  showType: DS.attr('string')
  ageRating: DS.attr('string')
  ageRatingGuide: DS.attr('string')
  episodeCount: DS.attr('number')
  episodeLength: DS.attr('number')
  startedAiring: DS.attr('date')
  finishedAiring: DS.attr('date')
  screencaps: DS.attr('array')

  franchise: DS.hasMany('anime', async: true)
  featuredQuotes: DS.hasMany('quote')

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

  formattedAirDates: (->
    if @get('startedAiring')
      formattedStartedAiring = moment(@get('startedAiring')).format("D MMM YYYY")
    else
      formattedStartedAiring = "?"

    if @get('finishedAiring')
      formattedFinishedAiring = moment(@get('finishedAiring')).format("D MMM YYYY")
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

Hummingbird.AnimeSerializer = Hummingbird.ApplicationSerializer.extend
  normalize: (type, hash, property) ->
    hash['links'] = {
      "franchise": "/api/v2/anime/" + hash['id'] + "/franchise"
    }
    @_super(type, hash, property)

