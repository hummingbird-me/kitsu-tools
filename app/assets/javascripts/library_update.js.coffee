@initializeRatingInterface = (element, type) ->
  rating = parseInt element.attr("data-rating")
  anime_slug = element.attr("data-anime-slug")
  element.html ""

  if type == "starRatings"
    for i in [1..5]
      star = $("<a class='star' data-rating='" + i + "' href='javascript: void(0)'></a>")
      if rating >= i
        star.append $("<i class='icon icon-star'></i>")
      else
        star.append $("<i class='icon icon-star-empty'></i>")

      star.click ->
        element.find('.spinner').html $("<i class='pull-right icon icon-spin icon-spinner'></i>")

        $.post "/api/v1/libraries/" + anime_slug, {rating: parseInt($(this).attr("data-rating"))}, (d) ->
          if d
            console.log d.rating.value
            element.attr "data-rating", d.rating.value
            initializeRatingInterface element, type

      element.append star
      element.append $("<span> </span>")
      
  else if type == "smileyRatings"
    
    console.log "to be implemented"
    
  
  element.append $("<div class='spinner pull-right'></div>")
  
renderProgress = (element) ->

@initializeProgressIncrement = (element) ->
  anime_slug      = element.attr("data-anime-slug")
  progress        = element.attr("data-progress")
  total_episodes  = element.attr("data-total-episodes")
  allow_incr      = element.attr("data-allow-increment") == "true"
  
  if allow_incr
    icon = $("<a href='javascript:void(0)' class='click-add'><i class='icon icon-angle-up'></i></a>")
    icon.click ->
      icon.find("i").removeClass("icon-angle-up").addClass("icon-spin").addClass("icon-spinner")
      $.post "/api/v1/libraries/" + anime_slug, {increment_episodes: true}, (d) ->
        element.attr "data-progress", d.episodes_watched 
        initializeProgressIncrement element
  else
    icon = $("<span></span>")
  
  element.empty()
  element.append icon
  element.append "<span> </span>"
  element.append "<span class='edit'>" + progress + "</span>"
  element.append " / "
  element.append "<span class='total-episodes'>" + total_episodes + "</span>"

@initializeWatchlistStatusButton = (element) ->
  unless currentUser
    element.append $("<a href='/users/sign_in' class='button radius padded'>Add to Watchlist</a>")
    return

  element.empty()
  
  anime = element.attr("data-anime")
  status = element.attr("data-status")
  statusParams = ["plan-to-watch", "currently-watching", "completed", "on-hold", "dropped"]
  statusHumanizer = {
    "plan-to-watch": "Plan to Watch",
    "currently-watching": "Currently Watching",
    "completed": "Completed",
    "on-hold": "On Hold",
    "dropped": "Dropped"
  }
  
  # Create the actual button.
  dropdownId = anime + "-status-dropdown"
  element.append $("<a class='button radius padded' href='javascript:void(0)' data-dropdown='" + dropdownId + "'></a>")
  if status == "false"
    element.find("a").html "Add to Watchlist"
  else
    element.find("a").addClass("secondary").html statusHumanizer[status]
    
  # Now, onto the dropdown.
  element.append $("<ul class='f-dropdown status-button' id='" + dropdownId + "'></ul>")
  _.each statusParams, (statusParam) ->
    if status != statusParam
      dropdownItem = $("<li><a href='javascript:void(0)'></a></li>")
      dropdownItem.find("a").html statusHumanizer[statusParam]
      dropdownItem.click ->
        $.post "/api/v1/libraries/" + anime, {status: statusParam}, (d) ->
          element.attr "data-status", d.status
          initializeWatchlistStatusButton element
      element.find("ul").append dropdownItem
  # Add "Remove" item.
  if status != "false"
    dropdownItem = $("<li><a href='javascript:void(0)'></a></li>")
    dropdownItem.find("a").html "Remove"
    dropdownItem.click ->
      $.post "/watchlist/remove", {anime_id: anime}, (d) ->
        if d
          element.attr "data-status", "false"
          initializeWatchlistStatusButton element
    element.find("ul").append dropdownItem

$ ->
  $(".watchlist-status-button").each ->
    initializeWatchlistStatusButton $(this)
