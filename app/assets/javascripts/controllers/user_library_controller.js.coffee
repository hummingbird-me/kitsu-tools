Hummingbird.UserLibraryController = Ember.ArrayController.extend
  needs: "user"
  user: Ember.computed.alias('controllers.user')
  reactComponent: null

  filter: ""
  sortBy: "lastWatched"
  sortAsc: false

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
    sortProperty = @get('sortBy')
    sortAsc = if @get('sortAsc') then 1 else -1

    @get('sectionNames').forEach (name) ->
      agg[name] = []

    @get('content').forEach (item) ->
      if (filter.length == 0) or (item.get('anime.searchString').indexOf(filter) >= 0)
        agg[item.get('status')].push item

    @get('sections').forEach (section) ->
      sortedContent = agg[section.get('title')].sort (a, b) ->
        aProp = a.get(sortProperty)
        bProp = b.get(sortProperty)

        if aProp < bProp
          -1 * sortAsc
        else if aProp == bProp
          0
        else
          1 * sortAsc

      section.set 'content', sortedContent
  ).observes('content.@each.status', 'filter', 'sortBy', 'sortAsc')

  actuallyNotifyReactComponent: ->
    if @get('reactComponent')
      @get('reactComponent').forceUpdate()

  notifyReactComponent: (->
    Ember.run.once this, 'actuallyNotifyReactComponent'
  ).observes('filter', 'showSection', 'sortBy', 'sortAsc',
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
    setSort: (newSort) ->
      if @get('sortBy') == newSort
        if @get('sortAsc')
          @set 'sortAsc', false
        else
          @set 'sortBy', 'lastWatched'
      else
        @set 'sortBy', newSort
        @set 'sortAsc', true

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

    removeFromLibrary: (libraryEntry) ->
      anime = libraryEntry.get('anime')
      Messenger().expectPromise (-> libraryEntry.destroyRecord()),
        progressMessage: "Removing " + anime.get('canonicalTitle') + " from your library..."
        successMessage: "Removed " + anime.get('canonicalTitle') + " from your library!"


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

