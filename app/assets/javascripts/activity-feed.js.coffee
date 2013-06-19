SubstoryModel = Backbone.Model.extend
  decoratedJSON: ->
    json = this.toJSON()
    json["type"] = {}
    json["type"][this.get("substory_type")] = true
    return json

StoryModel = Backbone.Model.extend
  initialize: ->
    this.set "substories", _.map(this.get("substories"), (x) -> new SubstoryModel(x))
    that = this
    _.each this.get("substories"), (x) ->
      x.set("user", that.get("user"))

  decoratedJSON: ->
    json = this.toJSON()
    json["type"] = {}
    json["type"][this.get("story_type")] = true
    json["substories"] = _.map this.get("substories"), (x) -> x.decoratedJSON()
    return json

StoryCollection = Backbone.Collection.extend {}

StoryView = Backbone.View.extend {}

@getUserFeedItems = (user, page) ->
  $.getJSON "/api/v1/users/" + user + "/feed?page=" + page, (feedItems) ->
    subFeed = $("<div/>")
    template = HandlebarsTemplates["stories/story"]
    _.each feedItems, (item) ->
      model = new StoryModel(item)
      subFeed.append template(model.decoratedJSON())
    $(".activity-feed").append subFeed
  
