Hummingbird.Manga = DS.Model.extend
  romajiTitle: DS.attr('string')
  englishTitle: DS.attr('string')
  coverImage: DS.attr('string')
  coverImageTopOffset: DS.attr('string')
  posterImage: DS.attr('string')
  synopsis: DS.attr('string')
  type: DS.attr('string')
  volumeCount: DS.attr('number')
  chapterCount: DS.attr('number')
  genres: DS.attr('array')

  mangaLibraryEntry: DS.belongsTo('mangaLibraryEntry')

  displayTitle: (->
    # HACK! No way right now to inject the current user into models.
    currentUser = Hummingbird.__container__.lookup('controller:currentUser')
    title = @get('romajiTitle')
    title = @get('englishTitle') if title == null
    if currentUser.get('isSignedIn')
      pref = currentUser.get('titleLanguagePreference')
      if pref == "english" and @get('englishTitle') and @get('englishTitle').length > 0
        title = @get('englishTitle')
      else if pref == "romanized" and @get('romajiTitle') and @get('romajiTitle').length > 0
        title = @get('romajiTitle')
    title
  ).property('englishTitle', 'romajiTitle')

  lowercaseDisplayTitle: (->
    @get('displayTitle').toLowerCase()
  ).property('englishTitle', 'romajiTitle')

  searchString: (->
    str = @get('englishTitle')
    if @get('englishTitle') and @get('englishTitle').length > 0
      str += @get('englishTitle')
    if @get('romajiTitle') and @get('romajiTitle').length > 0
      str += @get('romajiTitle')
    str.toLowerCase()
  ).property('englishTitle', 'romajiTitle')

  displayChapterCount: (->
    e = @get('chapterCount')
    if e
      e
    else
      "?"
  ).property('chapterCount')
