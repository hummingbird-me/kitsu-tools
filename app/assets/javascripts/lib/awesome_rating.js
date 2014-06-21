var roundSimpleRating = function(rating) {
  if (Ember.isNone(rating)) {
    return null;
  }

  if (rating > 2.4 && rating < 3.6) {
    return 3;
  } else if (rating < 3) {
    return 1;
  } else {
    return 5;
  }
};

var simpleRatingIcons = {
  1: 'fa fa-frown-o',
  3: 'fa fa-meh-o',
  5: 'fa fa-smile-o'
};

var advancedRatingIcons = ['fa fa-star-o', 'fa fa-star-half-o', 'fa fa-star'];

var nearestHalf = function(number) {
  if (Ember.isNone(number)) {
    return null;
  }
  return Math.floor(number * 2) / 2;
};

var starFor = function(rating, i) {
  if (nearestHalf(rating) - i > -0.01) {
    return advancedRatingIcons[2];
  } else if (nearestHalf(rating) - i > -0.51) {
    return advancedRatingIcons[1];
  } else {
    return advancedRatingIcons[0];
  }
};

var renderStars = function(rating) {
  var stars = "";
  for (var i = 1; i <= 5; i++) {
    stars += "<span class='icon-container' data-rating='" + i + "'><i class='" + starFor(rating, i) + "'></i></span>";
  }
  return stars;
};

$.fn.AwesomeRating = function(options) {
  return this.each(function() {
    var _results;
    var widget = this,
      rating = options["rating"];
    $(widget).empty();
    $(widget).unbind();
    if (options["editable"]) {
      $(widget).addClass("editable");
    }
    if (options["type"] === "simple") {
      // Simple ratings.
      rating = roundSimpleRating(rating);
      // Loop through 1,3,5.
      for (var i = 1; i <= 5; i += 2) {
        var icon = $("<span class='icon-container' data-rating='" + i + "'><i></i></span>");
        icon.find("i").addClass(simpleRatingIcons[i]);
        if (rating === i) {
          icon.find("i").addClass("active");
        }
        if (options["editable"]) {
          icon.css('cursor', 'pointer');
          icon.click(function() {
            var newRating = roundSimpleRating($(this).attr("data-rating"));
            return options["update"](newRating);
          });
        }
        _results.push($(this).append(icon));
      }
      return _results;
    } else {
      // Advanced ratings.
      rating = nearestHalf(rating);
      $(widget).html(renderStars(rating));
      if (options["editable"]) {
        $(widget).css('cursor', 'pointer');
        return $(widget).bind({
          mousemove: function(e) {
            var newRating = nearestHalf(5 * (e.pageX - $(widget).offset().left) / $(widget).width() + 0.5);
            return $(widget).find(".icon-container").each(function() {
              var index = $(this).attr("data-rating"),
                starClass = starFor(newRating, index);
              return $(this).find("i").removeClass('fa-star').removeClass('fa-star-half-o').removeClass('fa-star-o').addClass(starClass);
            });
          },
          mouseleave: function() {
            return $(widget).html(renderStars(rating));
          },
          click: function(e) {
            var newRating = nearestHalf(5 * (e.pageX - $(widget).offset().left) / $(widget).width() + 0.5);
            return options["update"](newRating);
          }
        });
      }
    }
  });
};
