var renderProgress;

this.initializeRatingInterface = function(element, type) {
  var anime_slug, i, rating, star, _i;
  return;
  rating = parseInt(element.attr("data-rating"));
  anime_slug = element.attr("data-anime-slug");
  element.html("");
  if (type === "starRatings") {
    for (i = _i = 1; _i <= 5; i = ++_i) {
      star = $("<a class='star' data-rating='" + i + "' href='javascript: void(0)'></a>");
      if (rating >= i) {
        star.append($("<i class='fa fa-star'></i>"));
      } else {
        star.append($("<i class='fa fa-star-o'></i>"));
      }
      star.click(function() {
        element.find('.spinner').html($("<i class='pull-right fa fa-spin fa-spinner'></i>"));
        return $.post("/api/v1/libraries/" + anime_slug, {
          rating: parseInt($(this).attr("data-rating"))
        }, function(d) {
          if (d) {
            element.attr("data-rating", d.rating.value);
            return initializeRatingInterface(element, type);
          }
        });
      });
      element.append(star);
      element.append($("<span> </span>"));
    }
  } else if (type === "smileyRatings") {
    console.log("to be implemented");
  }
  return element.append($("<div class='spinner pull-right'></div>"));
};

renderProgress = function(element) {};

this.initializeProgressIncrement = function(element) {
  var allow_incr, anime_slug, icon, progress, total_episodes;
  anime_slug = element.attr("data-anime-slug");
  progress = element.attr("data-progress");
  total_episodes = element.attr("data-total-episodes");
  allow_incr = element.attr("data-allow-increment") === "true";
  if (allow_incr) {
    icon = $("<a href='javascript:void(0)' class='click-add'><i class='fa fa-angle-up'></i></a>");
    icon.click(function() {
      icon.find("i").removeClass("fa-angle-up").addClass("fa-spin").addClass("fa-spinner");
      return $.post("/api/v1/libraries/" + anime_slug, {
        increment_episodes: true
      }, function(d) {
        element.attr("data-progress", d.episodes_watched);
        return initializeProgressIncrement(element);
      });
    });
  } else {
    icon = $("<span></span>");
  }
  element.empty();
  element.append(icon);
  element.append("<span> </span>");
  element.append("<span class='edit'>" + progress + "</span>");
  element.append(" / ");
  return element.append("<span class='total-episodes'>" + total_episodes + "</span>");
};

this.initializeWatchlistStatusButton = function(element) {
  var anime, entryModel, status, widget;
  if (!currentUser) {
    element.append($("<a href='/users/sign_in' class='button radius padded'>Add to Watchlist</a>"));
    return;
  }
  element.empty();
  anime = element.attr("data-anime");
  status = element.attr("data-status");
  entryModel = new HB.Library.Entry({
    anime: {
      slug: anime
    },
    status: status
  });
  widget = new HB.Library.StatusChangeWidget({
    model: entryModel
  });
  return element.append(widget.render().el);
};

$(function() {
  return $(".watchlist-status-button").each(function() {
    return initializeWatchlistStatusButton($(this));
  });
});
