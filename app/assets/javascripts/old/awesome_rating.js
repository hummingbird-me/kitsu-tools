var advancedRatingIcons, nearestHalf, renderStars, roundSimpleRating, simpleRatingIcons, starFor;

roundSimpleRating = function(rating) {
  if (rating === null || rating === "null" || rating === "") {
    return null;
  } else {
    rating = parseFloat(rating);
  }
  if (rating > 2.4 && rating < 3.6) {
    return 3;
  } else if (rating < 3) {
    return 1;
  } else {
    return 5;
  }
};

simpleRatingIcons = {
  1: 'fa fa-frown-o',
  3: 'fa fa-meh-o',
  5: 'fa fa-smile-o'
};

advancedRatingIcons = ['fa fa-star-o', 'fa fa-star-half-o', 'fa fa-star'];

nearestHalf = function(number) {
  if (number === null || number === "null" || number === "") {
    return null;
  } else {
    return Math.floor(number * 2) / 2;
  }
};

starFor = function(rating, i) {
  if (nearestHalf(rating) - i > -0.01) {
    return advancedRatingIcons[2];
  } else if (nearestHalf(rating) - i > -0.51) {
    return advancedRatingIcons[1];
  } else {
    return advancedRatingIcons[0];
  }
};

renderStars = function(rating) {
  var i, stars, _i;
  stars = "";
  for (i = _i = 1; _i <= 5; i = ++_i) {
    stars += "<span class='icon-container' data-rating='" + i + "'><i class='" + starFor(rating, i) + "'></i></span>";
  }
  return stars;
};

$.fn.AwesomeRating = function(options) {
  return this.each(function() {
    var i, icon, rating, widget, _i, _len, _ref, _results;
    widget = this;
    rating = $(widget).attr("data-rating");
    $(widget).empty();
    if (options["editable"]) {
      $(widget).addClass("editable");
    }
    if (options["type"] === "simple") {
      rating = roundSimpleRating(rating);
      _ref = [1, 3, 5];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        icon = $("<span class='icon-container' data-rating='" + i + "'><i></i></span>");
        icon.find("i").addClass(simpleRatingIcons[i]);
        if (rating === i) {
          icon.find("i").addClass("active");
        }
        if (options["editable"]) {
          icon.css('cursor', 'pointer');
          icon.click(function() {
            var done, newRating;
            newRating = roundSimpleRating($(this).attr("data-rating"));
            done = function(newRating) {
              if (newRating === null) {
                newRating = "";
              }
              $(widget).attr('data-rating', newRating);
              return $(widget).AwesomeRating(options);
            };
            return options["update"](newRating, widget, done);
          });
        }
        _results.push($(this).append(icon));
      }
      return _results;
    } else {
      rating = nearestHalf(rating);
      $(widget).html(renderStars(rating));
      if (options["editable"]) {
        $(widget).css('cursor', 'pointer');
        return $(widget).bind({
          mousemove: function(e) {
            var newRating;
            newRating = nearestHalf(5 * (e.pageX - $(widget).offset().left) / $(widget).width() + 0.5);
            return $(widget).find(".icon-container").each(function() {
              var index, starClass;
              index = $(this).attr("data-rating");
              starClass = starFor(newRating, index);
              return $(this).find("i").removeClass('fa-star').removeClass('fa-star-half-o').removeClass('fa-star-o').addClass(starClass);
            });
          },
          mouseleave: function() {
            return $(widget).html(renderStars(rating));
          },
          click: function(e) {
            var done, newRating;
            newRating = nearestHalf(5 * (e.pageX - $(widget).offset().left) / $(widget).width() + 0.5);
            done = function(newRating) {
              if (newRating === null) {
                newRating = "";
              }
              $(widget).attr('data-rating', newRating);
              return $(widget).AwesomeRating(options);
            };
            return options["update"](newRating, widget, done);
          }
        });
      }
    }
  });
};
