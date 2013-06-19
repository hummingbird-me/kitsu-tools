SubstoryModel = Backbone.Model.extend
  decoratedJSON: ->
    json = this.toJSON()
    json["type"] = {}
    json["type"][this.get("substory_type")] = true
    return json

StoryModel = Backbone.Model.extend
  initialize: ->
    substories = this.get("substories")

    substoriesCollection = new SubstoryCollectionClass
    this.set "substories", substoriesCollection

    that = this
    _.each substories, (x) -> x.user = that.get("user")
    
    substoriesCollection.add substories

SubstoryCollectionClass = Backbone.Collection.extend
  model: SubstoryModel
  comparator: (substory) ->
    return -moment(substory.get("created_at")).unix()

StoryCollection = new Backbone.Collection
StoryCollection.model = StoryModel
StoryCollection.comparator = (story) ->
  return -moment(story.get("updated_at")).unix()

StoryView = Backbone.View.extend
  initialize: -> this.expanded = false
  template: HandlebarsTemplates["stories/story"]
  
  render: ->
    json = this.model.toJSON()
    json["type"] = {}
    json["type"][this.model.get("story_type")] = true
    
    json["morethantwo"] = json["substories"].length > 2
    json["additional"] = json["substories"].length - 2
      
    json["substories"] = json["substories"].map (s) ->
      q = s.toJSON()
      q["type"] = {}
      q["type"][s.get("substory_type")] = true
      return q
    
    unless this.expanded
      json["substories"] = json["substories"].slice(0, 2)
    
    json["expanded"] = this.expanded
    
    this.$el.html this.template(json)
    
    that = this
    this.$el.find("a.show-more").click ->
      that.toggleExpand()
      
  toggleExpand: ->
    this.expanded = !this.expanded
    this.render()
    
StoryCollectionViewClass = Backbone.View.extend
  initialize: ->
    _(this).bindAll 'add', 'remove'
    this.views = {}
    this.collection.bind 'add', this.add
    this.collection.bind 'remove', this.remove
    this.loadedAll = false
    this.fetchInProgress = false
  add: (story) ->
    this.views[story.cid] = new StoryView
      model: story
  remove: (story) ->
    delete this.views[story.cid]
  render: ->
    this.$el.empty()
    that = this
    this.collection.each (model) ->
      view = that.views[model.cid]
      view.render()
      that.$el.append view.$el
    $(".activity-feed").append this.$el
  fetchMore: (baseURL) ->
    unless this.loadedAll or this.fetchInProgress
      page = 1 + Math.floor(this.collection.length / 20)
      this.fetchInProgress = true
      that = this
      $.ajax baseURL + "page=" + page,
        dataType: "json"
        error: -> that.fetchInProgress = false
        success: (feedItems) ->
          that.fetchInProgress = false
          if feedItems.length < 20
            that.loadedAll = true
            $(".activity-feed-spinner").hide()
          that.collection.add feedItems
          that.render()

@StoryCollectionView = new StoryCollectionViewClass
  collection: StoryCollection
  
@getUserFeedItems = (user) ->
  StoryCollectionView.fetchMore "/api/v1/users/" + user + "/feed?"
