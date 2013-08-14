_.extend HB,
  Library:
    validStatuses: ["currently-watching", "plan-to-watch", "completed", "on-hold", "dropped"]
    
    statusParamToHuman: {
      "currently-watching": "Currently Watching",
      "plan-to-watch": "Plan to Watch",
      "completed": "Completed",
      "on-hold": "On Hold",
      "dropped": "Dropped"
    }
    
    # Model for individual library entries.
    Entry: Backbone.Model.extend
      defaults:
        # Unless specified otherwise, assume that this entry belongs to the
        # current user.
        currentUser: true

      # Update the corresponding entry in the server.
      update: (data) ->
        if currentUser
          data.anime_id = @get("anime").slug
          that = this
          $.post "/api/v1/libraries/" + data.anime_id, data, (d) ->
            that.set d

      remove: ->
        that = this
        $.post "/watchlist/remove", {anime_id: @get("anime").slug}, (d) ->
          if d
            status = that.get("status")
            that.set {status: null}
            HB.Library.Sections[status].entries.remove that
            
      decoratedJSON: ->
        json = @toJSON()
        if json.anime.episode_count == 0
          json.anime.episode_count = "?"
        json.formattedLastUpdateTime = moment(@get("last_watched")).format('MMMM Do YYYY')
        if (json.status == "currently-watching" or json.status == "plan-to-watch") and (json.anime.status != "Finished Airing")
          if json.anime.status == "Currently Airing"
            json.anime.status = "Airing"
          else if json.anime.status == "Not Yet Aired"
            json.anime.status = "Upcoming"
        else
          json.anime.status = null
        return json

    # Collection class for storing all of the LibraryEntries in a particular
    # section.
    SectionCollection: Backbone.Collection.extend
      initialize: ->
        @on "change:status", (model, newStatus) ->
          if newStatus
            oldStatus = model.previous("status")
            newStatus = model.get("status")
            HB.Library.Sections[oldStatus].entries.remove model
            HB.Library.Sections[newStatus].entries.add model

            HB.statusBar.text 'Moved ' + model.get("anime").title + ' to your "' + HB.Library.statusParamToHuman[newStatus] + '" list.'
            HB.statusBar.action "Undo", ->
              model.update {status: oldStatus}
            HB.statusBar.show()
          
      sortByParameter: "lastWatchedDesc"
      setSortByParameter: (param) ->
        @sortByParameter = param
        @sort()
      comparator: (c) ->
        if this.sortByParameter == "lastWatchedDesc"
          return HB.utils.negateString(c.get("last_watched"))
        else if this.sortByParameter == "title"
          return c.get("anime").title.toLowerCase()
        else if this.sortByParameter == "titleDesc"
          return HB.utils.negateString c.get("anime").title.toLowerCase()
        else if this.sortByParameter == "progress"
          return c.get("episodes_watched")
        else if this.sortByParameter == "progressDesc"
          return -c.get("episodes_watched")
        else if this.sortByParameter == "rating"
          if c.get("rating").value == "-"
            return 0
          else
            return c.get("rating").value
        else if this.sortByParameter == "ratingDesc"
          if c.get("rating").value == "-"
            return 0
          else
            return -c.get("rating").value
        else if this.sortByParameter == "type"
          return c.get("anime").show_type
        else if this.sortByParameter == "typeDesc"
          return HB.utils.negateString c.get("anime").show_type
        
    # Wrapper model for section collections.
    Section: Backbone.Model.extend
      defaults:
        fetched: false
      initialize: ->
        @entries = new HB.Library.SectionCollection []
        
    # Collection of all possible watchlist sections.
    Sections: {}
    
    # Rating view.
    RatingView: Backbone.View.extend
      tagName: "div"
      className: "rating"
      
      initialize: ->
        _(this).bindAll 'change'
        @model.bind 'change', @change

      change: ->
        @render()
        
      render: ->
        that = this

        @$el.empty()
        rating = @model.get("rating")

        @$el.append "<div class='rating " + rating.type + "' data-rating='" + rating.value + "'></div>"
        @$el.find(".rating").AwesomeRating
          type: rating.type
          editable: @model.get("currentUser")
          update: (newRating, element, done) ->
            that.model.update {rating: newRating}
            done(newRating)

        return this
    
    # Episode increment view.
    EpisodeIncrementView: Backbone.View.extend
      tagName: "span"

      initialize: ->
        _(this).bindAll 'change'
        @model.bind 'change', @change
        
      change: ->
        @render()
      
      render: ->
        if @model.get("currentUser")
          icon = $("<span class='increment'><a href='javascript:void(0)'><i class='icon-angle-up'></i></a> </span>")
          that = this
          icon.click ->
            $(this).find("i").removeClass("icon-angle-up").addClass("icon-spin").addClass("icon-spinner")
            that.model.update {increment_episodes: true}
        else
          icon = ""
          
        episode_count = @model.get("anime").episode_count
        if episode_count == 0
          episode_count = "?"

        @$el.empty()
        @$el.append icon
        @$el.append "<span class='viewed-episodes'>" + @model.get("episodes_watched") + " </span>"
        @$el.append "<span class='out-of'>/ </span>"
        @$el.append "<span class='total-episodes'>" + episode_count + "</span>"
          
        return this

    StatusChangeWidget: Backbone.View.extend
      initialize: ->
        _(this).bindAll 'render'
        @model.bind 'change', @render

      render: ->
        @$el.empty()
        dropdownId = @model.get("anime").slug + "-status-dropdown"
        @$el.append "<a class='button secondary radius padded' href='javascript:void(0)' data-dropdown='" + dropdownId + "'></a>"
        console.log @model.get "status"
        if _.contains HB.Library.validStatuses, @model.get("status")
          @$el.find("a").html HB.Library.statusParamToHuman[@model.get("status")]
        else
          @$el.find("a").removeClass "secondary"
          @$el.find("a").html "Add to Library"
        # Dropdown
        @$el.append "<ul class='f-dropdown status-button' id='" + dropdownId + "'></ul>"
        that = this
        _.each HB.Library.validStatuses, (statusParam) ->
          if that.model.get("status") != statusParam
            dropdownItem = $("<li><a href='javascript: void(0)'></a></li>")
            dropdownItem.find("a").html HB.Library.statusParamToHuman[statusParam]
            dropdownItem.click ->
              that.model.update {status: statusParam}
            that.$el.find("ul").append dropdownItem
        # Remove link.
        if @model.get("status")
          dropdownItem = $("<li><a href='javascript: void(0)'></a></li>")
          dropdownItem.find("a").html "Remove"
          dropdownItem.click ->
            that.model.remove()
          @$el.find("ul").append dropdownItem

        return this
    
    # Single entry view.
    EntryView: Backbone.View.extend
      tagName: "tr"
      template: HandlebarsTemplates["library/entry"]
      dropdownTemplate: HandlebarsTemplates["library/dropdown"]
      
      initialize: ->
        _(this).bindAll 'change'
        @model.bind 'change', @change
        @dropdownOpen = false

      change: ->
        @render()
        @updateDropdown()
        
      toggleDropdown: ->
        if @dropdownOpen
          @hideDropdown()
        else
          @showDropdown()
          
      showDropdown: ->
        unless @dropdownOpen
          HB.Library.Sections[@model.get("status")]
          # TODO Close any other dropdown open in this section.
          @trigger("dropdownOpen")
          @$el.after @dropdownTemplate @model.decoratedJSON()
          @dropdown = @$el.next()
          @dropdown.find(".dropdown-content").slideDown "fast"
          @dropdownOpen = true
          @initializeDropdown()

      updateDropdown: ->
        if @dropdownOpen
          newDropdown = $(@dropdownTemplate @model.decoratedJSON())
          newDropdown.find(".dropdown-content").show()
          @dropdown.replaceWith newDropdown
          @dropdown = @$el.next()
          @initializeDropdown()
          
      hideDropdown: ->
        if @dropdownOpen
          that = this
          @dropdown.find(".dropdown-content").slideUp "fast", ->
            that.dropdown.remove()
          @dropdownOpen = false
      
      initializeDropdown: ->
        if @dropdownOpen
          if @model.get "currentUser"
            that = this
            # Rating.
            ratingView = new HB.Library.RatingView
              model: @model
            statusChangeWidget = new HB.Library.StatusChangeWidget
              model: @model
            @dropdown.find(".rating-widget").append ratingView.render().el
            @dropdown.find(".status-change-widget").append statusChangeWidget.render().el
            @dropdown.find("option[value=" + (if @model.get("private") then "private" else "public") + "]").prop("selected", true)
            # Submit updates when needed.
            @dropdown.find("form.custom").submit -> that.submitDropdownForm()
            @dropdown.find("form.custom").change -> that.submitDropdownForm()
            # Submit notes form.
            @dropdown.find("form.notes-form").change ->
              that.dropdown.find("form.notes-form .saving-indicator").show()
              notes = that.dropdown.find("form.notes-form textarea").val()
              that.model.update {"notes": notes}
          
      dropdownLoading: ->
        $(".opacity-wrapper").addClass "updating"
        $(".updating-icon").removeClass "hide"
        
      submitDropdownForm: ->
        @dropdownLoading()
        data = {}
        _.each @dropdown.find("form.custom").serializeArray(), (x) ->
          data[x.name] = x.value
        @model.update data
        return false
          
      render: ->
        decoratedJSON = @model.decoratedJSON()
        decoratedJSON.rating =
          type:
            star_rating: @model.get("rating").type == "advanced"
            simple: @model.get("rating").type == "simple"
          value: @model.get("rating").value
          negative: @model.get("rating").value <= 2.4
          neutral: @model.get("rating").value > 2.4 and @model.get("rating").value < 3.6
          positive: @model.get("rating").value >= 3.6
        @$el.html @template decoratedJSON
        that = this
        @$el.find("td:first").click ->
          that.toggleDropdown()

        episodeIncrementView = new HB.Library.EpisodeIncrementView
          model: @model
        @$el.find(".episode-count").html episodeIncrementView.render().el
        
        return this
    
    # Library Section view.
    SectionView: Backbone.View.extend
      tagName: "div"
      template: HandlebarsTemplates["library/section"]
      
      initialize: ->
        _(this).bindAll 'change', 'add', 'remove', 'closeAllDropdowns'
        @model.bind 'change', @change
        @model.entries.bind 'sort', @change
        @model.entries.bind 'add', @add
        @model.entries.bind 'remove', @remove
        @views = {}
        if $.jStorage.get("sortOrder_" + @model.get("status"))
          @setSortOrder $.jStorage.get("sortOrder_" + @model.get("status"))
        
      add: (model) ->
        @views[model.get("anime").slug] = new HB.Library.EntryView
          model: model
        @views[model.get("anime").slug].bind "dropdownOpen", @closeAllDropdowns
          
      remove: (model) ->
        delete @views[model.get("anime").slug]
        @render()

      change: ->
        @render()
        
      render: ->
        that = this
        json = @model.toJSON()
        
        if @model.get("fetched")
          json.entryCount = @model.entries.length
          
        @$el.html @template json
        
        # Render list entries.
        if @model.get("fetched")
          tbody = $("<tbody class='fake-table-row library-item'></tbody>")
          @model.entries.each (e) ->
            tbody.append that.views[e.get("anime").slug].render().el
          @$el.find(".library-item").replaceWith tbody
          
        # Display correct sort indicator.
        sortOrder = @model.entries.sortByParameter
        @$el.find(".sortOptions a").removeClass("active")
        @$el.find(".sortOptions a i").removeClass("icon-sort-down").removeClass("icon-sort-up").addClass("icon-sort")
        if sortOrder.substr(-4) == "Desc"
          param = sortOrder.substr(0, sortOrder.length-4)
        else
          param = sortOrder
        anchor = @$el.find(".sortOptions a[data-sortparam='" + param + "']")
        if sortOrder.substr(-4) == "Desc"
          anchor.find("i").removeClass("icon-sort").addClass("icon-sort-down")
        else
          anchor.find("i").removeClass("icon-sort").addClass("icon-sort-up")
        anchor.addClass("active")

        # Activate sorting options.
        @$el.find(".sortOptions a").click ->
          param = $(this).attr("data-sortparam")
          that.setSortOrderToNext(param)
          
        return this
      
      setSortOrder: (sortOrder) ->
        section = @model.get("status")
        $.jStorage.set "sortOrder_" + section, sortOrder
        @model.entries.setSortByParameter sortOrder
        
      setSortOrderToNext: (param) ->
        if param == @model.entries.sortByParameter
          param = param + "Desc"
        else if param == @model.entries.sortByParameter.substr(0, @model.entries.sortByParameter.length - 4)
          param = "lastWatchedDesc"

        @setSortOrder param
        
      
      closeAllDropdowns: ->
        _.each (_.values @views), (view) ->
          view.hideDropdown()
      
# Keep track of the LibraryEntries in each section of the Library.
_.each HB.Library.validStatuses, (status) ->
  HB.Library.Sections[status] = new HB.Library.Section
    status: status
    humanStatus: HB.Library.statusParamToHuman[status]
