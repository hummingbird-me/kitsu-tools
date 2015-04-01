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

const FAUNA_ICONS = [
  'panda', 'koala', 'ostrich', 'sloth', 'rhinoceros', 'tapir', 'red-panda',
  'opposom', 'lynx', 'elephant',	'owl', 'camel', 'lion', 'tiger', 'cheetah',
  'hippo', 'walrus', 'sea-lion', 'hyena', 'poodle', 'husky', 'afgan-hound',
  'chihuahua', 'golden-retriever', 'bulldog', 'hamster', 'maltese', 'warthog',
  'bull-terrier', 'beagle', 'pigeon', 'chicken', 'bald-eagle', 'sparrow',
  'pig', 'mouse', 'skunk', 'wolf', 'raccoon', 'fox', 'gorilla', 'monkey',
  'baboon', 'tarsier', 'orangutan', 'proboscis-monkey', 'turtle', 'donkey',
  'zebra', 'unicorn', 'horse', 'bull', 'cow', 'african-buffalo', 'wildebeest',
  'duck', 'swan', 'giraffe', 'antelope', 'goat', 'ram', 'cat', 'sphynx',
  'reindeer', 'rabbit', 'peacock', 'flamingo', 'bat', 'cobra', 'snake', 'frog',
  'toad', 'bear'
];
const FAUNA_PER = 5.0 / FAUNA_ICONS.length;

var getFaunaIcon = function (rating) {
  var i = Math.floor(rating / FAUNA_PER);
  return 'icon-' + FAUNA_ICONS[Math.min(i, FAUNA_ICONS.length-1)];
};

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
    var _results = [];
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
        icon.find("i").addClass(simpleRatingIcons[i] + " simple");
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
    } else if (options["type"] === "fauna") {
      // Fauna ratings.
      if (options['editable']) { // EDITABLE
        var cont = $('<div class="dropdown"></div>');
        // The current icon
        var icon = $('<a aria-haspopup="true" aria-expanded="false" style="cursor:pointer" href="javascript:;"><i class="' + getFaunaIcon(rating) + '"></i></a>').appendTo(cont);
        // The options to display
        var dropdownCont = $('<div class="fauna-select"></div>').appendTo(cont);
        var dropdown = $('<ul class="fauna-select-menu" role="menu">').appendTo(dropdownCont);
        FAUNA_ICONS.forEach(function (name, i) {
          var humanName = name.split('-').map(function (w) {
            return w.charAt(0).toUpperCase() + w.substr(1).toLowerCase();
          }).join(' ');
          dropdown.append('<li data-rating="' + i + '" class="fauna-select-item">' +
                            '<i class="fauna-icon icon-' + name + '"></i>' +
                            '<span class="fauna-name">' + humanName + '</span>' +
                          '</li>');
        });

        // The event handling
        icon.on('click', function() {
          dropdownCont.toggle();
          $('html').toggleClass('scroll-lock');
        });
        dropdown.on('click', function(e) {
          $('html').removeClass('scroll-lock');
          dropdownCont.hide();
          var newRating = $(e.target).closest('li').attr('data-rating') * FAUNA_PER;
          return options["update"](newRating);
        });
      } else if (!rating) { // OPTION
        var cont = $('<span></span>');
        var interval = FAUNA_ICONS.length / 4;
        for (var i = 0, l = FAUNA_ICONS.length; i < l; i += interval) {
          cont.append('&nbsp;<i class="icon-' + FAUNA_ICONS[Math.floor(i)] + '"></i>');
        }
      } else { // UNEDITABLE
        var cont = $('<span><i class="' + getFaunaIcon(rating) + '"></i></span>');
      }
      cont.appendTo(widget);
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
