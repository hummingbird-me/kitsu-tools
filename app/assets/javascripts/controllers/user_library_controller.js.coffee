Hummingbird.UserLibraryController = Ember.ArrayController.extend
  needs: "user"
  user: Ember.computed.alias('controllers.user')
  reactComponent: null

  sectionNames: ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"]
  showSection: "Currently Watching"
  showAll: Ember.computed.equal('showSection', 'View All')

  sections: (->
    that = this
    @get('sectionNames').map (name) ->
      Ember.Object.create
        title: name
        content: []
        visible: (name == that.get('showSection')) or that.get('showAll')
        displayVisible: name == that.get('showSection')
  ).property('sectionNames')

  updateSectionVisibility: (->
    that = this
    @get('sections').forEach (section) ->
      name = section.get('title')
      section.setProperties
        visible: (name == that.get('showSection')) or that.get('showAll')
        displayVisible: name == that.get('showSection')

    @notifyReactComponent()
  ).observes('showSection', 'showAll')

  updateSectionContents: (->
    agg = {}
    @get('sectionNames').forEach (name) ->
      agg[name] = []
    @get('content').forEach (item) ->
      agg[item.get('status')].push item
    @get('sections').forEach (section) ->
      section.set 'content', agg[section.get('title')]

    @notifyReactComponent()
  ).observes('content.@each.status')

  notifyReactComponent: ->
    if @get('reactComponent')
      @get('reactComponent').forceUpdate()
      console.log 'notified react component.'

  actions:
    showSection: (section) ->
      if typeof(section) == "string"
        @set 'showSection', section
      else
        @set 'showSection', section.get('title')

