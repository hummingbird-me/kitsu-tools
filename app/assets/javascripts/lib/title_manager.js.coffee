Hummingbird.TitleManager = Ember.Object.extend(
  title: null

  # Public interface for setting page titles.
  setTitle: (title) ->
    @set 'title', title

  # Observer that gets triggered whenever the title is changed.
  setPageTitle: (->
    if @get("title")
      @actuallySetTitle @get("title") + " | Hummingbird"
    else
      @actuallySetTitle "Hummingbird"
  ).observes('title').on('init')

  # Actually set the page title.
  actuallySetTitle: (title) ->
    document.title = title
    $("meta[name='og:title']").attr 'content', title
).create()
