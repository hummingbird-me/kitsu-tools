Hummingbird.UserLibraryController = Ember.ArrayController.extend
  needs: "user"
  user: Ember.computed.alias('controllers.user')
  reactComponent: null

  filter: ""

  sectionNames: ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"]
  showSection: "Currently Watching"
  showAll: (->
    @get('showSection') == "View All" or @get('filter').length > 0
  ).property('showSection', 'filter')

  sections: (->
    that = this
    @get('sectionNames').map (name) ->
      Ember.Object.create
        title: name
        content: []
        visible: (name == that.get('showSection')) or that.get('showAll')
        displayVisible: (name == that.get('showSection')) and !that.get('showAll')
  ).property('sectionNames')

  updateSectionVisibility: (->
    that = this
    @get('sections').forEach (section) ->
      name = section.get('title')
      section.setProperties
        visible: (name == that.get('showSection')) or that.get('showAll')
        displayVisible: (name == that.get('showSection')) and !that.get('showAll')
  ).observes('showSection', 'showAll')

  updateSectionContents: (->
    agg = {}
    filter = @get('filter').toLowerCase()

    @get('sectionNames').forEach (name) ->
      agg[name] = []

    @get('content').forEach (item) ->
      if (filter.length == 0) or (item.get('anime.canonicalTitle').toLowerCase().indexOf(filter) >= 0)
        agg[item.get('status')].push item

    @get('sections').forEach (section) ->
      section.set 'content', agg[section.get('title')].sortBy('lastWatched').reverse()
  ).observes('content.@each.status', 'filter')

  notifyReactComponent: (->
    Ember.run.once this, ->
      if @get('reactComponent')
        @get('reactComponent').forceUpdate()
  ).observes('filter', 'showSection',
             'content.@each.episodesWatched',
             'content.@each.status',
             'content.@each.rating',
             'content.@each.private',
             'content.@each.episodesWatched',
             'content.@each.notes',
             'content.@each.rewatchCount',
             'content.@each.rewatching')

  saveLibraryEntry: (libraryEntry) ->
    title = libraryEntry.get('anime.canonicalTitle')
    Messenger().expectPromise (-> libraryEntry.save()),
      progressMessage: "Saving " + title + "..."
      successMessage: "Saved " + title + "!"

  actions:
    showSection: (section) ->
      if typeof(section) == "string"
        @set 'showSection', section
      else
        @set 'showSection', section.get('title')

    setStatus: (libraryEntry, newStatus) ->
      libraryEntry.set 'status', newStatus

      if newStatus == "Completed" and libraryEntry.get('anime.episodeCount') and libraryEntry.get('episodesWatched') != libraryEntry.get('anime.episodeCount')
        libraryEntry.set 'episodesWatched', libraryEntry.get('anime.episodeCount')
        Messenger().post "Marked all episodes as watched."

      @saveLibraryEntry(libraryEntry)

    setPrivate: (libraryEntry, newPrivate) ->
      libraryEntry.set 'private', newPrivate
      @saveLibraryEntry(libraryEntry)

    setRating: (libraryEntry, newRating) ->
      if libraryEntry.get('rating') == newRating
        newRating = null
      libraryEntry.set 'rating', newRating
      @saveLibraryEntry(libraryEntry)

    toggleRewatching: (libraryEntry) ->
      currentState = libraryEntry.get('rewatching')
      if currentState
        libraryEntry.set 'rewatching', false
      else
        libraryEntry.set 'rewatching', true
        if libraryEntry.get('status') != "Currently Watching"
          libraryEntry.set 'status', "Currently Watching"
          libraryEntry.set 'episodesWatched', 0
          Messenger().post "Moved " + libraryEntry.get('anime.canonicalTitle') + " to Currently Watching."
      @saveLibraryEntry(libraryEntry)

    saveLibraryEntry: (libraryEntry) ->
      @saveLibraryEntry(libraryEntry)

    saveEpisodesWatched: (libraryEntry) ->
      if libraryEntry.get('anime.episodeCount') and libraryEntry.get('episodesWatched') == libraryEntry.get('anime.episodeCount')
        if libraryEntry.get('status') != "Completed"
          Messenger().post "Marked " + libraryEntry.get('anime.canonicalTitle') + " as complete."
          libraryEntry.set 'status', "Completed"
      @saveLibraryEntry(libraryEntry)

