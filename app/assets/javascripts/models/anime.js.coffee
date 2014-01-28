Hummingbird.Anime = DS.Model.extend
  canonicalTitle: DS.attr('string')
  englishTitle: DS.attr('string')
  romajiTitle: DS.attr('string')
  synopsis: DS.attr('string')
  posterImage: DS.attr('string')
  showType: DS.attr('string')
  ageRating: DS.attr('string')
  ageRatingGuide: DS.attr('string')
  episodeCount: DS.attr('number')
  episodeLength: DS.attr('number')
  startedAiring: DS.attr('date')
  startedAiringDateKnown: DS.attr('boolean')
  finishedAiring: DS.attr('date')

  libraryEntry: DS.belongsTo('libraryEntry')

  nsfw: (-> @get('ageRating') == "R18+" or @get('ageRating') == "R17+").property('ageRating')

  displayTitle: (->
    # HACK! No way right now to inject the current user into models.
    currentUser = Hummingbird.__container__.lookup('controller:currentUser')
    title = @get('canonicalTitle')
    if currentUser.get('isSignedIn')
      pref = currentUser.get('titleLanguagePreference')
      if pref == "english" and @get('englishTitle') and @get('englishTitle').length > 0
        title = @get('englishTitle')
      else if pref == "romanized" and @get('romajiTitle') and @get('romajiTitle').length > 0
        title = @get('romajiTitle')
    title
  ).property('canonicalTitle', 'englishTitle', 'romajiTitle')

  lowercaseDisplayTitle: (->
    @get('displayTitle').toLowerCase()
  ).property('canonicalTitle')

  searchString: (->
    str = @get('canonicalTitle')
    if @get('englishTitle') and @get('englishTitle').length > 0
      str += @get('englishTitle')
    if @get('romajiTitle') and @get('romajiTitle').length > 0
      str += @get('romajiTitle')
    str.toLowerCase()
  ).property('canonicalTitle', 'englishTitle', 'romajiTitle')

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

    if (@get('episodeCount') and @get('episodeCount') == 1) or (formattedStartedAiring == formattedFinishedAiring and formattedStartedAiring != "?")
      result += " on " + formattedStartedAiring
    else
      result += " from " + formattedStartedAiring
      if formattedFinishedAiring != "?"
        result += " to " + formattedFinishedAiring

    result
  ).property('startedAiring', 'finishedAiring')

